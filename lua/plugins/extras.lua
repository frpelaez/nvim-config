return {
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			require("mini.icons").setup()

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	{
		"leath-dub/snipe.nvim",
		keys = {
			{
				"<leader>h",
				function()
					require("snipe").open_buffer_menu()
				end,
				desc = "Open [S]nipe buffer menu",
			},
		},
		opts = {
			ui = {
				---@type integer
				max_height = -1, -- -1 means dynamic height
				-- Where to place the ui window
				-- Can be any of "topleft", "bottomleft", "topright", "bottomright", "center", "cursor" (sets under the current cursor pos)
				---@type "topleft"|"bottomleft"|"topright"|"bottomright"|"center"|"cursor"
				position = "center",
				-- Override options passed to `nvim_open_win`
				-- Be careful with this as snipe will not validate
				-- anything you override here. See `:h nvim_open_win`
				-- for config options
				---@type vim.api.keyset.win_config
				open_win_override = {
					title = "Snipe this one",
					border = "rounded", -- use "rounded" for rounded border
				},
				-- Preselect the currently open buffer
				---@type boolean
				preselect_current = false,
				-- Changes how the items are aligned: e.g. "<tag> foo    " vs "<tag>    foo"
				-- Can be "left", "right" or "file-first"
				-- NOTE: "file-first" puts the file name first and then the directory name

				---@type "left"|"right"|"file-first"
				text_align = "file-first",
			},
		},
	},
	{
		"mg979/vim-visual-multi",
		branch = "master",
		init = function()
			-- La configuración de teclas debe ir aquí, antes de que cargue el plugin
			vim.g.VM_maps = {
				["Find Under"] = "<C-n>",  -- (Opcional) Selecciona la palabra bajo el cursor
				-- ["Find Subword Under"] = "<C-n>", -- (Opcional) Igual que arriba
				["Add Cursor Down"] = "<C-j>", -- TÚ QUIERES ESTO: Ctrl + j para cursor abajo
				["Add Cursor Up"] = "<C-k>", -- TÚ QUIERES ESTO: Ctrl + k para cursor arriba
			}
		end,
	},
}
