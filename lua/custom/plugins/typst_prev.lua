local typst_jobs = {}

local function toggle_typst_preview()
	local bufnr = vim.api.nvim_get_current_buf()
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	local filename = vim.fn.fnamemodify(filepath, ":")
	local file_dir = vim.fn.fnamemodify(filepath, ":h")

	local project_root = vim.fn.getcwd()

	if not filepath:match("%.typ") then
		vim.notify("Current file is not a Typst file (.typ)", vim.log.levels.WARN)
		return
	end

	if typst_jobs[bufnr] then
		vim.fn.jobstop(typst_jobs[bufnr])
		typst_jobs[bufnr] = nil
		vim.notify("Typst Watch stopped for " .. filename, vim.log.levels.INFO)
		return
	end

	local job_id = vim.fn.jobstart({ "typst", "watch", filepath, "--root", project_root }, {
		cwd = file_dir,
		on_stderr = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" and line:lower():match("error") then
						vim.schedule(function()
							vim.notify("Typst: " .. line, vim.log.levels.ERROR)
						end)
					end
				end
			end
		end,
		on_exit = function(_, code, _)
			typst_jobs[bufnr] = nil
			if code ~= 0 and code ~= 143 then
				vim.notify("Process 'typst watch' finished unexpectedly", vim.log.levels.ERROR)
			end
		end,
	})

	if job_id <= 0 then
		vim.notify("Error launching 'typst watch'", vim.log.levels.ERROR)
		return
	end

	typst_jobs[bufnr] = job_id
	vim.notify("Typst Watch started for " .. filename, vim.log.levels.INFO)

	vim.api.nvim_create_autocmd("BufDelete", {
		buffer = bufnr,
		callback = function()
			if typst_jobs[bufnr] then
				vim.fn.jobstop(typst_jobs[bufnr])
				typst_jobs[bufnr] = nil
			end
		end,
		once = true,
	})

	local pdf_path = filepath:gsub("%.typ$", ".pdf")

	vim.fn.jobstart({ "C:\\Users\\franp\\AppData\\Local\\SumatraPDF\\SumatraPDF.exe", pdf_path }, { detach = true })
end

vim.api.nvim_create_user_command(
	"ToggleTypstPreview",
	toggle_typst_preview,
	{ desc = "Toggle 'typst' watch and open compiled pdf in with SumatraPDF" }
)
