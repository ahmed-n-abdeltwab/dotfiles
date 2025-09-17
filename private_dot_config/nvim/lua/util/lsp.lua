local mapkey = require("util.keymapper").mapvimkey

local M = {}

M.on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }


	if client.name == "pyright" then
		mapkey("<leader>dbi", "PyrightOrganizeImports", "n", opts) -- organise imports
		mapkey("<leader>dbb", "DapToggleBreakpoint", "n", opts) -- toggle breakpoint
		mapkey("<leader>dbc", "DapContinue", "n", opts) -- continue/invoke debugger
		mapkey("<leader>dbt", "lua require('dap-python').test_method()", "n", opts) -- run tests
	end

end

M.typescript_organise_imports = {
	description = "Organise Imports",
	function()
		local params = {
			command = "_typescript.organizeImports",
			arguments = { vim.fn.expand("%:p") },
		}
		-- reorganise imports
		vim.lsp.buf.execute_command(params)
	end,
}

return M
