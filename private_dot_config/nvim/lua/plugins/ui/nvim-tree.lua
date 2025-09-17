return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  config = function()
    local api = require("nvim-tree.api")
    
    -- Performance-oriented configuration
    require("nvim-tree").setup({
      hijack_directories = {
        enable = false,  -- Prevent auto-opening directories
        auto_open = false,
      },
      update_focused_file = {
        enable = true,
        update_root = false,  -- Disable root updates on focus
        debounce_delay = 1500,  -- Slow down updates
      },
      renderer = {
        add_trailing = false,
        group_empty = true,  -- Collapse empty folders
        highlight_git = true,  -- Disable git highlights
        icons = {
          webdev_colors = true,
          git_placement = "signcolumn",
          show = {
            file = true,  -- Simplify display
            folder = true,
            folder_arrow = true,
          },
        },
        indent_markers = {
          enable = false,
        },
        special_files = {},  -- No special treatment for config files
      },
      view = {
        adaptive_size = true,
        centralize_selection = true,
        width = 35,
        hide_root_folder = false,
        side = "left",
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = "no",
      },
      filters = {
        dotfiles = false,
        custom = {
          "^.git$",
          "^node_modules$",
          "^__pycache__$",
          "^target$",
          "^dist$",
          "^build$",
          "^%.cache$",
          "^%.npm$",
          "^%.yarn$",
        },
        exclude = {},  -- Handled by custom filters
      },
      actions = {
        change_dir = {
          enable = false,  -- Prevent automatic directory changes
          restrict_above_cwd = false,
        },
        open_file = {
          quit_on_open = true,  -- Close tree after file open
          resize_window = false,
          window_picker = {
            enable = false,
          },
        },
        remove_file = {
          close_window = true,
        },
      },
      git = {
        enable = false,  -- Disable git integration in large dirs
        ignore = true,
        show_on_dirs = false,
        timeout = 300,
      },
      filesystem_watchers = {
        enable = false,  -- Disable filesystem watching
      },
      trash = {
        cmd = "gio trash",  -- Faster trash command
      },
      live_filter = {
        always_show_folders = false,  -- Don't force folder display
      },
      log = {
        enable = false,
        truncate = true,
        types = {
          diagnostics = false,
          git = false,
          profile = false,
        },
      },
    })

    -- Performance-aware keymaps
    vim.keymap.set("n", "<leader>e", function()
      local path = vim.fn.expand("%:p:h")
      if path:match("node_modules") or path:match("target") then
        api.tree.toggle({ find_file = true, focus = true })
      else
        api.tree.toggle({ focus = true })
      end
    end, { desc = "Toggle file tree" })
  end
}
