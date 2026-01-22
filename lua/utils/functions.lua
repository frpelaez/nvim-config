local M = {}

function M.map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = true
	return vim.keymap.set(mode, lhs, rhs, opts)
end

return M
