vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

local o = vim.opt

o.number = true
o.relativenumber = true
o.mouse = "a"
o.showmode = false
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.breakindent = true
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = "yes"
o.updatetime = 250
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
o.list = true
o.listchars = { tab = "  ", trail = "·", nbsp = "_" }
o.inccommand = "split"
o.cursorline = true
o.guicursor = "n-v-c:blinkon0-block,i-ci-ve:blinkon0-ver25,r-cr:blinkon0-hor20,o:blinkon0-hor50"
o.scrolloff = 10
o.confirm = true
o.clipboard = "unnamedplus"
o.winborder = "rounded"
o.fillchars = { eob = " " }
vim.o.shell = "pwsh.exe"
vim.g.R_path = [[C:\Program Files\R\R-4.5.1\bin\x64]]
vim.g.R_set_omnifunc = {}
