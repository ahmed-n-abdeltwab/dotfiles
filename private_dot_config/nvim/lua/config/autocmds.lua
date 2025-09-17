local M = {}

-- Define large directory patterns
local large_dirs = {
  "node_modules",
  "target",
  "dist",
  "build",
  "__pycache__",
  "%.git",
  "vendor",
}

-- Performance mode flag
vim.g.performance_mode = false

-- Session management for performance mode
local function save_session()
  vim.cmd("mksession! .nvimsession")
end

local function restore_session()
  if vim.fn.filereadable(".nvimsession") == 1 then
    vim.cmd("source .nvimsession")
  end
end

M.setup = function()
  -- Detect large directories and enable performance mode
  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("PerformanceMode", { clear = true }),
    callback = function(args)
      local path = vim.api.nvim_buf_get_name(args.buf)
      local is_large_dir = false
      
      -- Check if path contains any large directory patterns
      for _, pattern in ipairs(large_dirs) do
        if path:match(pattern) then
          is_large_dir = true
          break
        end
      end

      if is_large_dir and not vim.g.performance_mode then
        vim.g.performance_mode = true
        
        -- Save current state
        save_session()
        
        -- Disable heavy features
        vim.cmd("LspStop")
        vim.cmd("NvimTreeClose")
        vim.cmd("TSBufDisable highlight")
        
        -- Set minimal UI
        vim.opt.laststatus = 0    -- No status line
        vim.opt.showmode = false  -- No mode indicator
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.signcolumn = "no"
        
        -- Disable plugins
        pcall(function()
          require("telescope").reset()
          require("gitsigns").reset()
          require("illuminate").pause()
        end)
        
        vim.notify("⚠️ Entered performance mode for large directory", vim.log.levels.WARN)
      elseif not is_large_dir and vim.g.performance_mode then
        vim.g.performance_mode = false
        
        -- Restore previous state
        restore_session()
        vim.cmd("edit")  -- Refresh buffer
        
        -- Re-enable features
        vim.cmd("LspStart")
        vim.opt.laststatus = 3
        vim.opt.showmode = true
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.signcolumn = "yes"
        
        pcall(function()
          require("telescope").setup()
          require("gitsigns").setup()
          require("illuminate").resume()
        end)
      end
    end
  })

  -- Optimized format on save
  local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = lsp_fmt_group,
    callback = function()
      if vim.g.performance_mode then return end
      
      local efm = vim.lsp.get_clients({ name = "efm" })
      if not vim.tbl_isempty(efm) then
        vim.lsp.buf.format({
          name = "efm",
          async = true,
          timeout_ms = 3000,  -- Formatting timeout
          filter = function(client)
            return client.name == "efm"
          end
        })
      end
    end
  })

  -- Lightweight highlight on yank
  local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", { clear = true })
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = highlight_yank_group,
    callback = function()
      if vim.g.performance_mode then return end
      vim.hl.on_yank({
        higroup = "IncSearch",
        timeout = 150,  -- Reduced highlight time
        on_visual = false,
      })
    end
  })
end

return M
