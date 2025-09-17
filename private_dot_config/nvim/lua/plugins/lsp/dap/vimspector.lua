return {
    "puremourning/vimspector",
    lazy = true,
    config = function()
      vim.g.vimspector_enable_mappings = "HUMAN"
      vim.g.vimspector_base_dir = vim.fn.expand("$HOME/.config/nvim/vimspector")
    end,
    cmd = { "VimspectorInstall", "VimspectorUpdate" },
  };
