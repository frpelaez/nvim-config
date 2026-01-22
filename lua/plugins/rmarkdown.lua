vim.api.nvim_create_autocmd("FileType", {
	pattern = "rmd",
	callback = function()
		vim.keymap.set("n", "<localleader>k", function()
			local file = vim.fn.expand("%:p")
			local r_path = file:gsub("\\", "/")
			local r_cmd_string = string.format("rmarkdown::render('%s')", r_path)
			print("Compiling RMarkdown to HTML: " .. vim.fn.expand("%:t") .. " ...")
			vim.fn.jobstart({ "Rscript", "-e", r_cmd_string }, {
				on_exit = function(_, code)
					if code == 0 then
						print("✅ HTML generated successfully.")
					else
						print("❌ Error compiling HTML.")
					end
				end,
				on_stderr = function(_, data)
					if data then
						for _, line in ipairs(data) do
							if line ~= "" then
								vim.api.nvim_echo({ { line, "ErrorMsg" } }, true, {})
							end
						end
					end
				end,
			})
		end, { buffer = true, desc = "[K]nit Rmarkdown to HTML" })
	end,
})

return {
	{
		"R-nvim/R.nvim",
		lazy = false,
		config = function ()
			---@type RConfigUserOpts
			local opts = {
				disable_cmds = {
					"RInsertPipe"
				}
			}
			require("r").setup(opts)
		end
	},
}
