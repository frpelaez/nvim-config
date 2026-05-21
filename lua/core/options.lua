-- ============================================================
-- OPTIONS
-- ============================================================

-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Leaders (must be set before plugins load)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

local o = vim.opt

-- Line numbers
o.number = true
o.relativenumber = true

-- Mouse
o.mouse = 'a'

-- Don't show the mode (it's in the statusline)
o.showmode = false

-- Sync clipboard between OS and Neovim after UI loads
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Indentation defaults (overridden per-filetype in autocommands.lua)
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.breakindent = true

-- Persistent undo
o.undofile = true

-- Search
o.ignorecase = true
o.smartcase = true

-- UI
o.signcolumn = 'yes'
o.cursorline = true
o.scrolloff = 10
o.list = true
o.listchars = { tab = '  ', trail = '·', nbsp = '_' }
o.inccommand = 'split'
o.winborder = 'rounded'
o.fillchars = { eob = ' ' }

o.completeopt = 'menuone,fuzzy,nosort'

-- Cursor style (no blinking)
o.guicursor = 'n-v-c:blinkon0-block,i-ci-ve:blinkon0-ver25,r-cr:blinkon0-hor20,o:blinkon0-hor50'
-- o.guicursor = ''

-- Timings
o.updatetime = 250
o.timeoutlen = 300

-- Splits
o.splitright = true
o.splitbelow = true

-- Ask instead of failing on unsaved changes
o.confirm = true

-- Shell (Windows)
-- vim.o.shell = 'pwsh.exe'
