vim.pack.add { { src = Gh 'leath-dub/snipe.nvim' } }

local snipe = require 'snipe'

snipe.setup {
  ui = {
    ---@type integer
    max_height = -1,
    ---@type "topleft"|"bottomleft"|"topright"|"bottomright"|"center"|"cursor"
    position = 'center',
    ---@type vim.api.keyset.win_config
    open_win_override = {
      -- title = "My Window Title",
      border = 'rounded', -- use "rounded" for rounded border
    },

    ---@type boolean
    preselect_current = false,

    ---@type nil|fun(buffers: snipe.Buffer[]): number
    preselect = nil,

    -- NOTE: "file-first" puts the file name first and then the directory name
    ---@type "left"|"right"|"file-first"
    text_align = 'file-first',

    persist_tags = true,
  },
  hints = {
    ---@type string
    dictionary = 'sadflewcmpghio',
    prefix_key = '.',
  },
  navigate = {
    leader = ',',

    leader_map = {
      ['d'] = function(m, i) require('snipe').close_buf(m, i) end,
      ['v'] = function(m, i) require('snipe').open_vsplit(m, i) end,
      ['h'] = function(m, i) require('snipe').open_split(m, i) end,
    },

    next_page = 'J',
    prev_page = 'K',

    ---@type string|string[]
    under_cursor = '<cr>',

    ---@type string|string[]
    cancel_snipe = '<esc>',

    close_buffer = 'D',

    open_vsplit = 'V',

    open_split = 'H',

    -- Change tag manually (note only works if `persist_tags` is not enabled)
    -- change_tag = "C",
  },
  ---@type "last"|"default"|fun(buffers:snipe.Buffer[]):snipe.Buffer[]
  sort = 'default',
}

vim.keymap.set('n', '<C-e>', snipe.open_buffer_menu)
