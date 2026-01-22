local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "[A]dd buffer to Harpoon list" })
vim.keymap.set("n", "<leader>c", function()
	harpoon:list():clear()
end, { desc = "[C]lear Harpoon list" })

vim.keymap.set("n", "<C-q>", function()
	harpoon:list():prev()
end)
vim.keymap.set("n", "<C-e>", function()
	harpoon:list():next()
end)

-- vim.keymap.set("n", "<C-q>", function()
-- 	harpoon:list():select(1)
-- end)
-- vim.keymap.set("n", "<C-w>", function()
-- 	harpoon:list():select(2)
-- end)
-- vim.keymap.set("n", "<C-e>", function()
-- 	harpoon:list():select(3)
-- end)
-- vim.keymap.set("n", "<C-r>", function()
-- 	harpoon:list():select(4)
-- end)

vim.keymap.set("n", "<C-h>", function()
	harpoon.ui:toggle_quick_menu(
		harpoon:list(),
		{ title = " Harpoon ", title_pos = "center", style = "minimal", border = "rounded", bold = true }
	)
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff" })
	vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#ffffff", bold = true })
end)

-- local conf = require("telescope.config").values
-- local function toggle_telescope(harpoon_files)
-- 	local file_paths = {}
-- 	for _, item in ipairs(harpoon_files.items) do
-- 		table.insert(file_paths, item.value)
-- 	end
--
-- 	require("telescope.pickers")
-- 		.new({}, {
-- 			prompt_title = "Harpoon",
-- 			finder = require("telescope.finders").new_table({
-- 				results = file_paths,
-- 			}),
-- 			previewer = conf.file_previewer({}),
-- 			sorter = conf.generic_sorter({}),
-- 		})
-- 		:find()
-- end
-- vim.keymap.set("n", "<C-h>", function()
-- 	toggle_telescope(harpoon:list())
-- end, { desc = "Open harpoon window" })

local harpoon_extensions = require("harpoon.extensions")
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
