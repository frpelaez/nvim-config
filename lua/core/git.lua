-- ============================================================
-- GIT
-- gitsigns.nvim
-- ============================================================

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  signs = {
    add          = { text = '+' }, ---@diagnostic disable-line: missing-fields
    change       = { text = '~' }, ---@diagnostic disable-line: missing-fields
    delete       = { text = '_' }, ---@diagnostic disable-line: missing-fields
    topdelete    = { text = '‾' }, ---@diagnostic disable-line: missing-fields
    changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
  },

  on_attach = function(bufnr)
    local gs  = require 'gitsigns'
    local map = function(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'Git: ' .. desc })
    end

    -- Navigation
    map('n', ']h', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gs.nav_hunk 'next'
      end
    end, 'Next [H]unk')

    map('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gs.nav_hunk 'prev'
      end
    end, 'Prev [H]unk')

    -- Staging
    map('n',        '<leader>hs', gs.stage_hunk,                                        '[H]unk [S]tage')
    map('n',        '<leader>hr', gs.reset_hunk,                                        '[H]unk [R]eset')
    map('v',        '<leader>hs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, '[H]unk [S]tage (selection)')
    map('v',        '<leader>hr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, '[H]unk [R]eset (selection)')
    map('n',        '<leader>hS', gs.stage_buffer,                                      '[H]unk [S]tage buffer')
    map('n',        '<leader>hR', gs.reset_buffer,                                      '[H]unk [R]eset buffer')
    map('n',        '<leader>hu', gs.undo_stage_hunk,                                   '[H]unk [U]ndo stage')

    -- Inspection
    map('n',        '<leader>hp', gs.preview_hunk,                                      '[H]unk [P]review')
    map('n',        '<leader>hb', function() gs.blame_line { full = true } end,         '[H]unk [B]lame line')
    map('n',        '<leader>hd', gs.diffthis,                                          '[H]unk [D]iff this')
    map('n',        '<leader>hD', function() gs.diffthis '~' end,                       '[H]unk [D]iff against last commit')

    -- Toggles
    map('n',        '<leader>tb', gs.toggle_current_line_blame,                         '[T]oggle line [B]lame')
    map('n',        '<leader>td', gs.toggle_deleted,                                    '[T]oggle show [D]eleted')

    -- Text object: select a hunk
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>',                          'Select [H]unk')
  end,
}
