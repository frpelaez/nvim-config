local uv = vim.uv or vim.loop

local client = nil
local buf = nil
local data_buffer = ""

local function create_floating_window(width, height)
	buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"

	local ui = vim.api.nvim_list_uis()[1]
	local editor_width = ui.width
	local editor_height = ui.height

	local col = math.floor((editor_width - width) / 2)
	local row = math.floor((editor_height - height) / 2)

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	vim.api.nvim_open_win(buf, true, win_opts)

	vim.api.nvim_buf_set_name(buf, "Conway")
end

local function send_command(action)
	if client and not client:is_closing() then
		local msg = vim.fn.json_encode({ action = action })
		client:write(msg .. "\n")
	else
		print("Server connection is not established.")
	end
end

local function connect_to_server()
	create_floating_window(80, 24)

	client = uv.new_tcp()

	client:connect("127.0.0.1", 8080, function(err)
		if err then
			vim.schedule(function()
				print("Conway error: " .. err)
			end)
			return
		end

		vim.schedule(function()
			print("Conway: connecting to server...")
		end)

		client:read_start(function(read_err, chunk)
			if read_err then
				vim.schedule(function()
					print("Read error: " .. read_err)
				end)
				return
			end

			if chunk then
				data_buffer = data_buffer .. chunk

				while true do
					local newline_pos = data_buffer:find("\n")
					if not newline_pos then
						break
					end

					local line = data_buffer:sub(1, newline_pos - 1)
					data_buffer = data_buffer:sub(newline_pos + 1)

					vim.schedule(function()
						local ok, parsed = pcall(vim.fn.json_decode, line)

						if ok and parsed.type == "update" then
							if not buf or not vim.api.nvim_buf_is_valid(buf) then
								create_floating_window(parsed.width or 80, parsed.height or 24)
							end

							local formatted_grid = {}
							for _, row_str in ipairs(parsed.grid) do
								local replaced = row_str:gsub("0", " "):gsub("1", "█")
								table.insert(formatted_grid, replaced)
							end

							vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_grid)
						end
					end)
				end
			else
				client:close()
				vim.schedule(function()
					print("Conway: server closed the connection")
				end)
			end
		end)
	end)
end

vim.api.nvim_create_user_command("ConwayStart", connect_to_server, {})
vim.api.nvim_create_user_command("ConwayPause", function()
	send_command("pause")
end, {})
vim.api.nvim_create_user_command("ConwayResume", function()
	send_command("resume")
end, {})
vim.api.nvim_create_user_command("ConwayClose", function()
	send_command("disconnect")
end, {})
