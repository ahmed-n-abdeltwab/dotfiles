return {
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-ui",
  cmd = { "DBUI", "DB" },
  config = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end
}
