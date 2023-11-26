local M = {}

DEFAULT_CONFIG = {
	commentstring = "#%s",
	add_filtype = true,
}

function M.setup(opts)
	if not pcall(require, "nvim-treesitter.parsers") then
		vim.notify("nu-ts needs access to nvim-treesitter.parsers")
		return
	end

	local options = vim.tbl_extend("keep", opts or {}, DEFAULT_CONFIG)

	local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
	parser_config.nu = {
		install_info = {
			url = "https://github.com/nushell/tree-sitter-nu",
			files = { "src/parser.c" },
			branch = "main",
		},
		filetype = "nu",
	}

	if options.add_filtype then
		vim.filetype.add({
			extension = {
				nu = "nu",
			},
		})
	end

	local nu_ts_augroup = vim.api.nvim_create_augroup("nu_ts_ft", {})
	vim.api.nvim_create_autocmd("FileType", {
		group = nu_ts_augroup,
		pattern = { "*.nu" },
		callback = function()
			vim.opt.commentstring = options.commentstring
		end,
	})

	vim.opt.commentstring = options.commentstring
end

return M
