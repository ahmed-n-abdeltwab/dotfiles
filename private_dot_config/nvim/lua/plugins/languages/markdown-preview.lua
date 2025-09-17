return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
  run = "cd app && npm install",
	config = function()
    vim.g.mkdp_auto_start = 1  -- Automatically start preview
    vim.g.mkdp_auto_open = 1   -- Automatically open the preview
  end
}
