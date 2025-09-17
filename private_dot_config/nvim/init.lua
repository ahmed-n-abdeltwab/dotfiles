vim.loader.enable()  -- Enable new Lua module loader (Neovim 0.9+)

require("config")
vim.defer_fn(function()
  require("lazy").setup("plugins")
end, 100) -- Delay plugin setup by 100ms
