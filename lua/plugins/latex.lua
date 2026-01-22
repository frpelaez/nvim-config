return {
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "general"
			vim.g.vimtex_view_general_viewer = "SumatraPDF"
			vim.g.vimtex_compiler_method = "latexmk" -- Recommended compiler
			vim.g.vimtex_compiler_latexmk = {
				out_dir = "build",
				options = { "-pdf", "-interaction=nonstopmode", "-synctex=1" },
			}
		end,
	},
}
