local on_attach = require("util.lsp").on_attach
local diagnostic_signs = require("util.icons").diagnostic_signs
local typescript_organise_imports = require("util.lsp").typescript_organise_imports

-- Performance-oriented LSP configuration
local config = function()
  require("neoconf").setup({
    plugins = {
      lsp = {
        inlay_hints = false,  -- Disable resource-heavy features
        semantic_tokens = false
      }
    }
  })
  
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local lspconfig = require("lspconfig")
  local capabilities = cmp_nvim_lsp.default_capabilities()
  local util = require("lspconfig/util")

  -- Global exclude patterns for large directories
  local excluded_dirs = {
    "node_modules", "__pycache__", ".git", "dist", "build", "target", "vendor"
  }

  -- Enhanced on_attach with performance checks
  local global_on_attach = function(client, bufnr)
    local path = vim.api.nvim_buf_get_name(bufnr)
    for _, dir in ipairs(excluded_dirs) do
      if path:match(dir) then
        -- Disable non-essential features in large directories
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.codeLensProvider = nil
        client.server_capabilities.inlayHintProvider = false
        return
      end
    end
    on_attach(client, bufnr)
  end

  -- Common LSP settings
  local default_config = {
    capabilities = capabilities,
    on_attach = global_on_attach,
    flags = {
      debounce_text_changes = 300,  -- Increase debounce time
    }
  }

  -- Language Server Configurations
  lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", default_config, {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          checkThirdParty = false,
          maxPreload = 5000,  -- Limit preloaded files
          preloadFileSize = 500,  -- (KB)
        }
      }
    }
  }))

  lspconfig.pyright.setup(vim.tbl_deep_extend("force", default_config, {
    settings = {
      pyright = {
        disableOrganizeImports = true,
        analysis = {
          diagnosticMode = "openFilesOnly",
          typeCheckingMode = "basic",
          useLibraryCodeForTypes = false,
          autoSearchPaths = false
        }
      }
    }
  }))

  lspconfig.bashls.setup(vim.tbl_deep_extend("force", default_config, {
    filetypes = { "sh", "aliasrc", "zsh" }
  }))

  -- EFM Configuration with performance tweaks
  local efm_config = {
    init_options = {
      documentFormatting = true,
      hover = false,  -- Disable hover in large files
      completion = false
    },
    settings = {
      rootMarkers = { ".git/", ".luacheckrc", "package.json" },
      lintDebounce = "1s",  -- Slow down linting
      formatDebounce = "500ms"
    }
  }

  -- Merge with default config
  lspconfig.efm.setup(vim.tbl_deep_extend("force", default_config, efm_config))

  -- Diagnostic signs setup
  for type, icon in pairs(diagnostic_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
end

return {
  "neovim/nvim-lspconfig",
  config = config,
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "creativenull/efmls-configs-nvim",
    "hrsh7th/cmp-nvim-lsp"
  }
}
