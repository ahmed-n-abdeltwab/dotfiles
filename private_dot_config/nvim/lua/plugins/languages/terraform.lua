return {
  "hashivim/vim-terraform",
  ft = { "terraform", "tf", "hcl" },
  config = function()
    vim.g.terraform_fmt_on_save = 1 -- Auto-format
  end
}
