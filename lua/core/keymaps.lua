-- ============================================================
-- KEYMAPS
-- ============================================================
-- NOTE: LSP-specific keymaps live in lua/core/lsp.lua (LspAttach callback).
--       Git keymaps live in lua/core/git.lua.

local map = vim.keymap.set

-- ── General ────────────────────────────────────────────────────────────────
map('n', '<leader>w', ':write<CR>', { desc = 'Write buffer' })
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
-- map('n', '<leader>e', ':Explore<CR>', { desc = 'File [E]xplorer' })
map('n', '<leader>re', ':restart<CR>', { desc = '[RE]start neovim' })
map('x', 'p', [["_dP]], { desc = 'Paste over selection without losing yanked text' })

-- ── Diagnostics ────────────────────────────────────────────────────────────
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- ── Terminal ───────────────────────────────────────────────────────────────
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ── Window navigation ──────────────────────────────────────────────────────
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })

-- ── Fast vertical movement ─────────────────────────────────────────────────
map({ 'n', 'v' }, '<S-j>', '10j')
map({ 'n', 'v' }, '<S-k>', '10k')

-- ── Clipboard ──────────────────────────────────────────────────────────────
map({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })

-- ── LSP (non-attach) ───────────────────────────────────────────────────────
map('n', 'H', vim.lsp.buf.hover, { desc = '[H]over symbol' })

-- ── Formatting ─────────────────────────────────────────────────────────────
-- format keymap is defined in lsp.lua after conform loads

-- ── Python ─────────────────────────────────────────────────────────────────
map({ 'n', 'v' }, '<leader>si', '<cmd>!isort .<CR>', { desc = '[S]ort [I]mports' })

-- ── Line movement (visual) ─────────────────────────────────────────────────
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = 'Move line down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = 'Move line up' })

-- ── Typst ──────────────────────────────────────────────────────────────────
map('n', '<leader>tp', ':ToggleTypstPreview<CR>', { desc = '[T]oggle Typst [P]review' })
