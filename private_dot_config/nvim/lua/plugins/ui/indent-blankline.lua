return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  lazy = false,
  opts = {
    scope = { enabled = true }, -- Disable scope highlighting
    indent = {
      char = "│", -- Use a better character for indentation
    },
    exclude = {
      filetypes = { "help", "dashboard", "NvimTree", "Trouble", "lazy" }, -- Don't show indent lines in these
    },
  },
}

