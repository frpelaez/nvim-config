-- ============================================================
-- AUTOCOMMANDS
-- ============================================================

-- ── Yank highlight ─────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text briefly',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- ── Per-filetype indentation ───────────────────────────────────────────────
-- Lua and C-family: 2-space tabs, no expansion
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'c', 'h', 'cpp', 'hpp' },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = false
  end,
})

-- ── Format on save (fallback when conform is not handling a filetype) ───────
-- NOTE: conform.nvim (configured in lsp.lua) is the primary formatter.
--       This autocmd acts as a safety net for filetypes not covered there.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.lua', '*.go', '*.rs', '*.py', '*.c', '*.h', '*.cpp', '*.hpp' },
  callback = function() vim.lsp.buf.format() end,
})

-- ── Colorscheme overrides ──────────────────────────────────────────────────
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    -- Float borders & titles
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#ffffff' })
    vim.api.nvim_set_hl(0, 'FloatTitle', { fg = '#ffffff', bold = true })

    -- Completion menu
    vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#1e1e2e', fg = '#cdd6f4' })
    vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#a594f9', fg = '#1e1e2e', bold = true })
    vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#1e1e2e' })
    vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#585b70' })

    -- Fidget (LSP progress)
    vim.api.nvim_set_hl(0, 'FidgetTask', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'FidgetTitle', { bg = 'NONE' })
  end,
})

-- ── Netrw convenience mappings ─────────────────────────────────────────────
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    vim.keymap.set('n', 'l', '<CR>', { remap = true, buffer = true, desc = 'Open entry' })
    vim.keymap.set('n', 'h', '-', { remap = true, buffer = true, desc = 'Go up a directory' })
  end,
})

local rust_check_timer = nil
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.rs',
  callback = function()
    -- Cancela el timer anterior si guardas rápido varias veces
    if rust_check_timer then
      rust_check_timer:stop()
      rust_check_timer:close()
    end
    rust_check_timer = vim.uv.new_timer()
    rust_check_timer:start(
      1000,
      0,
      vim.schedule_wrap(function()
        vim.cmd 'RustLsp! flyCheck' -- el ! evita foco en el quickfix
        rust_check_timer:close()
        rust_check_timer = nil
      end)
    )
  end,
})
