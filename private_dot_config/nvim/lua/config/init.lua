-- Configure package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- Load utilities first
require("config.globals")
require("config.helpers").setup()
-- Load core config modules
require("config.options")
require("config.autocmds").setup()
-- Load plugins
require("plugins")
-- Load keymaps LAST
require("config.keymaps").setup()

-- Ensures lazygit.nvim tracks the Git root when entering a buffer
local function get_git_root()
  local git_cmd = "git rev-parse --show-toplevel 2>/dev/null"
  local root = vim.fn.systemlist(git_cmd)[1]
  return (vim.v.shell_error == 0) and root or vim.fn.getcwd()
end
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function() vim.g.lazygit_root_dir = get_git_root() end
})

-- Load LSP and DAP dynamically
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "lua", "javascript", "typescript", "go" },
  callback = function()
    require("plugins.lsp")
    require("plugins.lsp.dap")
  end,
})

-- Asynchronous startup optimizations
vim.defer_fn(function()
  vim.cmd("doautocmd User LazyDone")
  vim.cmd("silent! doautocmd FileType")
  require("plugins.ui.lualine")
end, 100)

-- Load minimal config in large directories
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*/node_modules/*,*/target/*,*/dist/*",
  callback = function()
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.signcolumn = "no"
    vim.opt_local.spell = false
    vim.opt_local.list = false
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
  group = vim.api.nvim_create_augroup("LargeDirSettings", { clear = true }),
})
