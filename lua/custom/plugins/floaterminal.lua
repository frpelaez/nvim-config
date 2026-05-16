local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}
local function open_float(opts)
	opts = opts or {}

	-- defaults to 80% of screen
	local width_ratio = opts.width or 0.8
	local height_ratio = opts.height or 0.8

	-- get editor dimensions
	local columns = vim.o.columns
	local lines = vim.o.lines

	-- calculate window size
	local win_width = math.floor(columns * width_ratio)
	local win_height = math.floor(lines * height_ratio)

	-- calculate centered position
	local col = math.floor((columns - win_width) / 2)
	local row = math.floor((lines - win_height) / 2 - 1) -- minus 1 for cmdheight

	-- create a scratch buffer
	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	-- create floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		style = "minimal",
		border = "rounded",
		width = win_width,
		height = win_height,
		col = col,
		row = row,
		title = " Powershell ",
		title_pos = "right",
	})

	vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff" })
	vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#ffffff", bold = true })

	vim.cmd("startinsert")

	return { buf = buf, win = win }
end

local function toggle_terminal()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = open_float({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
		end
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<leader>T", toggle_terminal, { desc = "[T]oggle floating terminal" })
