local M = {}

function M.setup()
  -- Define all key mappings in the new which-key spec format
  local keymaps = {
    -- Indentation
    { "<leader><", "<gv", desc = "Indent Left" },
    { "<leader>>", ">gv", desc = "Indent Right" },

    -- Buffer Navigation
    { "<leader>b", group = "Buffer" },
    { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
    { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
    { "<leader>bb", "<cmd>e #<cr>", desc = "Switch to Other Buffer" },
    { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },

    -- File Explorer
    { "<leader>e", group = "Explorer" },
    { "<leader>ee", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Explorer" },
    { "<leader>ef", "<cmd>NvimTreeFocus<cr>", desc = "Focus Explorer" },
    { "<leader>er", "<cmd>NvimTreeRefresh<cr>", desc = "Refresh Explorer" },

    -- Window Management
    { "<leader>w", group = "Windows" },
    { "<leader>wh", "<C-w>h", desc = "Navigate Left" },
    { "<leader>wj", "<C-w>j", desc = "Navigate Down" },
    { "<leader>wk", "<C-w>k", desc = "Navigate Up" },
    { "<leader>wl", "<C-w>l", desc = "Navigate Right" },
    { "<leader>ws", "<cmd>split<cr>", desc = "Horizontal Split" },
    { "<leader>wv", "<cmd>vsplit<cr>", desc = "Vertical Split" },
    { "<leader>wq", "<C-w>q", desc = "Close Window" },

    -- Tmux Navigation
    { "<leader>t", group = "Tmux" },
    { "<leader>th", "<cmd>TmuxNavigateLeft<cr>", desc = "Left Tmux Pane" },
    { "<leader>tj", "<cmd>TmuxNavigateDown<cr>", desc = "Down Tmux Pane" },
    { "<leader>tk", "<cmd>TmuxNavigateUp<cr>", desc = "Up Tmux Pane" },
    { "<leader>tl", "<cmd>TmuxNavigateRight<cr>", desc = "Right Tmux Pane" },

    -- Terraform Commands
    { "<leader>T", group = "Terraform" },
    { "<leader>Ta", "<cmd>!terraform apply<cr>", desc = "Apply Configuration" },
    { "<leader>Td", "<cmd>!terraform destroy<cr>", desc = "Destroy Infrastructure" },
    { "<leader>Tp", "<cmd>!terraform plan<cr>", desc = "Show Execution Plan" },

    -- File Operations
    { "<leader>f", group = "Files" },
    { "<leader>fs", "<cmd>w<cr>", desc = "Save File" },

    -- Code Actions
    { "<leader>c", group = "Code" },
    { "<leader>cc", "<Plug>(comment_toggle_linewise)", desc = "Toggle Comment" },
    { "<leader>cC", "<Plug>(comment_toggle_blockwise)", desc = "Block Comment" },

    -- LSP
    { "<leader>l", group = "LSP" },
    { "<leader>ld", vim.lsp.buf.definition, desc = "Go to Definition" },
    { "<leader>lR", vim.lsp.buf.references, desc = "References" },
    { "<leader>lr", vim.lsp.buf.rename, desc = "Rename Symbol" },
    { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
    { "<leader>lf", vim.lsp.buf.finder, desc = "Finder" },
    { "<leader>lP", vim.lsp.buf.peek_definition, desc = "peek definition" },
    { "<leader>lD", vim.lsp.buf.goto_definition, desc = "goto definition" },
    { "<leader>ll", vim.lsp.buf.show_line_diagnostics, desc = "show line diagnostics" },
    { "<leader>lc", vim.lsp.buf.show_cursor_diagnostics, desc = "show cursor diagnostics" },
    { "<leader>lp", vim.lsp.buf.diagnostic_jump_prev, desc = "diagnostic jump prev" },
    { "<leader>lh", vim.lsp.buf.hover_doc, desc = "hover doc" },
    { "<leader>ls", vim.lsp.buf.lsp_document_symbols, desc = "Show document symbols" },

    -- Debugging
    { "<leader>d", group = "Vimspector Debugger" },
    { "<leader>dc", "<cmd>VimspectorContinue<cr>", desc = "Continue" },
    { "<leader>dr", "<cmd>VimspectorReset<cr>", desc = "Reset" },
    { "<leader>db", "<cmd>VimspectorToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
    { "<leader>dO", "<cmd>VimspectorStepOver<cr>", desc = "Step Over" },
    { "<leader>di", "<cmd>VimspectorStepInto<cr>", desc = "Step Into" },
    { "<leader>do", "<cmd>VimspectorStepOut<cr>", desc = "Step Out" },
    { "<leader>dR", "<cmd>VimspectorRestart<cr>", desc = "Restart" },
  }

  -- Safe require with error handling
  local function safe_require_whichkey()
    local status, wk = pcall(require, "which-key")
    if not status then
      vim.notify("which-key.nvim not installed!", vim.log.levels.WARN)
      return nil
    end
    return wk
  end

  -- Delay registration to ensure plugins are loaded
  vim.defer_fn(function()
    local wk = safe_require_whichkey()
    if wk then
      wk.add(keymaps, { prefix = "<leader>" })
    else
      -- Fallback: Set basic mappings without which-key
      for _, mapping in ipairs(keymaps) do
        if not mapping.group then  -- Skip group definitions
          vim.keymap.set("gw", mapping[1], mapping[2], { desc = mapping.desc })
        end
      end
    end
  end, 200)

  -- Terminal mappings (unchanged)
  local term_mappings = {
    ["<C-A-h>"] = "<cmd>wincmd h<cr>",
    ["<C-A-j>"] = "<cmd>wincmd j<cr>",
    ["<C-A-k>"] = "<cmd>wincmd k<cr>",
    ["<C-A-l>"] = "<cmd>wincmd l<cr>",
  }

  for key, cmd in pairs(term_mappings) do
    vim.keymap.set("t", key, cmd, { noremap = true, silent = true })
  end

  -- Conditional TMUX mappings (unchanged)
  if vim.env.TMUX then
    vim.keymap.set({ "n", "v" }, "<C-_>", "<Plug>(comment_toggle_linewise)", { noremap = false })
  else
    vim.keymap.set({ "n", "v" }, "<C-/>", "<Plug>(comment_toggle_linewise)", { noremap = false })
  end
end

return M
