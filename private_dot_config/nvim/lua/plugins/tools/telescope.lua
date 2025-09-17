local keys = {
	{ "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer search" },
	{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
	{ "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
	{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find All Files" },
	{ "<leader>fS", "<cmd>Telescope git_files<cr>", desc = "Git files" },
	{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
	{ "<leader>fj", "<cmd>Telescope command_history<cr>", desc = "History" },
	{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
	{ "<leader>fl", "<cmd>Telescope lsp_references<cr>", desc = "Lsp References" },
	{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old files" },
	{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Ripgrep" },
	{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep String" },
	{ "<leader>ft", "<cmd>Telescope treesitter<cr>", desc = "Treesitter" },
}

local config = function()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local builtin = require("telescope.builtin")
  
  -- Performance-focused configuration
  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-c>"] = actions.close,
          ["<Esc>"] = actions.close
        }
      },
      dynamic_preview_title = true,
      cache_picker = {
        num_pickers = 20,
        limit_entries = 1000  -- Limit cached entries
      },
      file_ignore_patterns = {
        "%.7z$", "%.rar$", "%.zip$", "%.tar%.gz$", "%.mp4$", "%.mkv$",
        "node_modules/", "__pycache__/", "target/", "dist/", "%.o$", 
        "%.a$", "%.out$", "%.class$", "%.pdf$", "%.rpm$", "%.jpg$",
        "%.jpeg$", "%.png$", "%.svg$", "%.snap$", "%.cache$"
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--max-filesize=500kb",  -- File size limit
        "--glob=!*.min.*",       -- Exclude minified files
        "--glob=!package-lock.json",
        "--glob=!yarn.lock",
        "--hidden"
      },
      pickers = {
        find_files = {
          find_command = {
            "fd", 
            "--type", "f", 
            "--hidden",
            "--exclude", "{.git,node_modules,.cache,target,dist,build}",
            "--max-depth=8"  -- Prevent deep recursion
          }
        },
        live_grep = {
          additional_args = function(opts)
            return { "--max-depth=6" }  -- Limit search depth
          end
        }
      }
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case"
      }
    }
  })

  -- Custom picker for large directories
  builtin.large_directory_find = function()
    builtin.find_files({
      find_command = {
        "fd", 
        "--type", "f", 
        "--hidden",
        "--exclude", "{.git,node_modules}",
        "--max-depth=3",
        "--max-results=500"  -- Hard limit
      }
    })
  end

  telescope.load_extension("fzf")
end

return {
  "nvim-telescope/telescope.nvim",
  keys = keys,
  config = config,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim"
  }
}
