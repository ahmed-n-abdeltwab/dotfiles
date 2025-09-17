return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Load when opening a file
    config = function()
      require('gitsigns').setup({
        -- Add your configuration here (optional)
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        trouble = false, -- Disable Trouble.nvim integration
        watch_gitdir = {
          interval = 1000,
          follow_files = true
        },
        -- Keymaps (optional)
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']g', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '[g', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          -- Actions
          map('n', '<leader>gs', gs.stage_hunk)
          map('n', '<leader>gr', gs.reset_hunk)
          map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
          map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
          map('n', '<leader>gS', gs.stage_buffer)
          map('n', '<leader>gu', gs.undo_stage_hunk)
          map('n', '<leader>gR', gs.reset_buffer)
          map('n', '<leader>gp', gs.preview_hunk)
          map('n', '<leader>gB', function() gs.blame_line { full = true } end)
          map('n', '<leader>gb', gs.toggle_current_line_blame)
          map('n', '<leader>gd', gs.diffthis)
          map('n', '<leader>gD', function() gs.diffthis('~') end)
          map('n', '<leader>g`', gs.toggle_deleted)
        end
      })
    end,
}
