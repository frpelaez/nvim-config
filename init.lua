-- ============================================================
-- init.lua
-- Entry point. Loads core modules then plugins.
-- ============================================================

require('vim._core.ui2').enable {}

-- ── Core (order matters) ──────────────────────────────────────────────────
require 'core.options' -- vim.opt / vim.g settings
require 'core.keymaps' -- global keymaps
require 'core.autocommands' -- autocmds (yank hl, indent, colorscheme overrides…)
require 'core.git' -- gitsigns + git keymaps
require 'core.lsp' -- Mason · LSP · conform · blink.cmp · LuaSnip
require 'custom.plugins.rust'

-- ── Plugin manager helper ─────────────────────────────────────────────────
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ── UI / UX plugins ───────────────────────────────────────────────────────
do
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  if vim.g.have_nerd_font then vim.pack.add { gh 'nvim-tree/nvim-web-devicons' } end

  -- which-key
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- Colorscheme
  vim.pack.add { gh 'folke/tokyonight.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyonight').setup {
    styles = { comments = { italic = false, transparency = true } },
    -- vim.cmd.colorscheme 'tokyonight-night',
  }

  vim.pack.add {
    gh 'rose-pine/neovim',
  }
  require('rose-pine').setup {
    styles = {
      bold = true,
      italic = false,
      transparency = true,
    },
    highlight_groups = {
      Visual = { bg = 'overlay', fg = 'NONE' },
      VisualNOS = { bg = 'overlay' },
    },
  }
  vim.cmd.colorscheme 'rose-pine-moon'

  -- todo-comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- mini.nvim
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  require('mini.ai').setup {
    mappings = { around_next = 'aa', inside_next = 'ii' },
    n_lines = 500,
  }

  require('mini.surround').setup()

  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end

  local MiniFiles = require 'mini.files'
  MiniFiles.setup {
    mappings = {
      go_in_plus = '<L>',
      go_out_plus = '<H>',
    },
  }
  vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<CR>', { desc = 'Toggle mini file explorer' })
  vim.keymap.set('n', '<leader>E', function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
  end, { desc = 'Toggle mini file explorer into current file' })

  -- require('mini.notify').setup {
  --   content = {
  --     format = function(notif) return notif.msg end,
  --   },
  -- }

  -- require('mini.cmdline').setup {
  --   autocorrect = { enable = false },
  -- }

  vim.pack.add { gh 'stevearc/dressing.nvim' }
end

-- ── Search & navigation (Telescope) ──────────────────────────────────────
do
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
  }
  if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end
  vim.pack.add(telescope_plugins)

  require('telescope').setup {
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  }
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  local builtin = require 'telescope.builtin'
  local map = vim.keymap.set

  map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
  map('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find buffers' })

  map(
    'n',
    '<leader>/',
    function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end,
    { desc = '[/] Fuzzy search buffer' }
  )

  map(
    'n',
    '<leader>s/',
    function() builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' } end,
    { desc = '[S]earch [/] in Open Files' }
  )

  map('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim config files' })

  -- Telescope LSP pickers (attached per buffer)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf
      map('n', 'grr', builtin.lsp_references, { buffer = buf, desc = 'LSP: [G]oto [R]eferences' })
      map('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = 'LSP: [G]oto [I]mplementation' })
      map('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = 'LSP: [G]oto [D]efinition' })
      map('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'LSP: Document Symbols' })
      map('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'LSP: Workspace Symbols' })
      map('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = 'LSP: [G]oto [T]ype Definition' })
    end,
  })
end

-- ── Treesitter ────────────────────────────────────────────────────────────
do
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', branch = 'main' } }

  local parsers = {
    'bash',
    'c',
    'diff',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'go',
    'rust',
    'python',
  }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    if not vim.treesitter.language.add(language) then return end
    vim.treesitter.start(buf, language)
    local has_indent = vim.treesitter.query.get(language, 'indents') ~= nil
    if has_indent then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match
      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end
      local installed = require('nvim-treesitter').get_installed 'parsers'
      if vim.tbl_contains(installed, language) then
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        treesitter_try_attach(buf, language)
      end
    end,
  })

  vim.api.nvim_set_hl(0, 'LspInlayHint', {
    fg = '#a594f9',
    bg = 'NONE',
    italic = true,
  })
end

-- ── Optional / extra plugins ──────────────────────────────────────────────
require 'kickstart.plugins.autopairs'
require 'custom.plugins'

-- vim: ts=2 sts=2 sw=2 et
