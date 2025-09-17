local M = {}

-- Create custom user commands
function M.create_user_command(name, command, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, command, {
    bang = opts.bang or false,
    nargs = opts.nargs or 0,
    complete = opts.complete,
    desc = opts.desc,
  })
end

-- Reload Neovim configuration
function M.reload_config()
  local utils = require("utils")
  for name, _ in pairs(package.loaded) do
    if name:match("^config") or name:match("^plugins") then
      package.loaded[name] = nil
    end
  end
  vim.cmd("luafile $MYVIMRC")
  utils.info("Neovim configuration reloaded!")
end

-- Debugging setup helper
function M.setup_dap()
  local dap = require("dap")
  local dapui = require("dapui")
  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = { expand = { "l", "<CR>", "o" } },
  })
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
end

-- Toggle diagnostics visibility
function M.toggle_diagnostics()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
  require("util.icons").info("Diagnostics " .. (current and "hidden" or "shown"))
end

-- Show current file path
function M.show_path()
  local path = vim.fn.expand("%:p")
  vim.notify("File path: " .. path, vim.log.levels.INFO)
end

-- Check if plugin is loaded
function M.has_plugin(plugin_name)
  local lazy_config = require("lazy.core.config")
  return lazy_config.plugins[plugin_name] ~= nil
end

-- Create scratch buffer
function M.create_scratch()
  vim.cmd("enew | setl buftype=nofile bufhidden=wipe nobuflisted")
end

-- Performance profiling helper
function M.start_profile()
  vim.cmd("profile start nvim-profile.log")
  vim.cmd("profile func *")
  vim.cmd("profile file *")
  require("util.icons").info("Profiling started!")
end

-- Custom health check
function M.health_check()
  local health = {
    ["Neovim Version"] = vim.version(),
    ["Plugin Manager"] = "lazy.nvim",
    ["LSP Servers"] = vim.tbl_keys(vim.lsp.get_active_clients()),
    ["Treesitter Parsers"] = require("nvim-treesitter.info").installed_parsers(),
  }
  vim.notify(vim.inspect(health), vim.log.levels.INFO)
end

-- Setup helper commands
function M.setup()
  M.create_user_command("ReloadConfig", M.reload_config, {
    desc = "Reload Neovim configuration"
  })
  M.create_user_command("ToggleDiagnostics", M.toggle_diagnostics, {
    desc = "Toggle diagnostic visibility"
  })
  M.create_user_command("HealthCheck", M.health_check, {
    desc = "Show system health information"
  })
  M.create_user_command("ScratchBuffer", M.create_scratch, {
    desc = "Create a new scratch buffer"
  })
  M.create_user_command("StartProfile", M.start_profile, {
    desc = "Start performance profiling"
  })
end

return M
