vim.lsp.config("tinymist", {
	settings = {
		formatterMode = "typstyle",
		formatterIndentSize = 2,
		-- rootPath = "main.typ",
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.typ",
	callback = function()
		vim.lsp.buf.format()
	end,
})

return {
	-- {
	-- 	"chomosuke/typst-preview.nvim",
	-- 	lazy = false, -- or ft = 'typst'
	-- 	version = "1.*",
	-- 	opts = {
	-- 		dependencies_bin = { ["tinymist"] = "Users\\franp\\AppData\\Local\\nvim-data\\mason\\packages" },
	-- 	}, -- lazy.nvim will implicitly calls `setup {}`
	-- },
}
