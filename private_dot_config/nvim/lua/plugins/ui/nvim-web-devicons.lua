return {
  "nvim-tree/nvim-web-devicons",
  lazy = true, -- Load it only when needed
  config = function()
    require("nvim-web-devicons").setup {
      override = {},
      default = true,
    }
  end
}
