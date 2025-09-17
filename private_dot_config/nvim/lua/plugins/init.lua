return {
  { "folke/lazy.nvim" }, -- Ensure Lazy.nvim is explicitly loaded
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",
  require("plugins.editing"),
  require("plugins.languages"),
  require("plugins.lsp"),
  require("plugins.tools"),
  require("plugins.ui"),
  require("plugins.vcs"),
  
}
