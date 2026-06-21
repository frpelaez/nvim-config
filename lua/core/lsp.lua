-- ============================================================
-- LSP & FORMATTING
-- Mason · nvim-lspconfig · conform.nvim · blink.cmp · LuaSnip
-- ============================================================

function Gh(repo) return 'https://github.com/' .. repo end

-- ── Diagnostics config ────────────────────────────────────────────────────
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = {
    on_jump = function(_, bufnr) vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false } end,
  },
}

-- ── LSP attach: keymaps + highlight + inlay hints ─────────────────────────
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Document highlight on cursor hold
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local hl_group = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = hl_group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(ev2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = ev2.buf }
        end,
      })
    end

    -- Inlay hints toggle
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- ── LSP status (fidget) ───────────────────────────────────────────────────
vim.pack.add { Gh 'j-hui/fidget.nvim' }
require('fidget').setup {}

-- ── Language servers ──────────────────────────────────────────────────────
---@type table<string, vim.lsp.Config>
local servers = {
  -- Add / uncomment servers you want Mason to install & enable:
  ols = {},
  clangd = {},
  gopls = {},
  black = {},
  ruff = {},
  pyrefly = {},
  tinymist = {},
  typstyle = {},
  stylua = {},
  lua_ls = {
    on_init = function(client)
      -- Let conform/stylua handle formatting
      client.server_capabilities.documentFormattingProvider = false

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        -- workspace = {
        --   checkThirdParty = false,
        --   library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
        --     '${3rd}/luv/library',
        --     '${3rd}/busted/library',
        --   }),
        -- },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = { format = { enable = false }, diagnostics = { globals = { 'vim' } } },
    },
  },
}

vim.pack.add {
  Gh 'neovim/nvim-lspconfig',
  Gh 'mason-org/mason.nvim',
  Gh 'mason-org/mason-lspconfig.nvim',
  Gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}

require('mason').setup {}
require('mason-tool-installer').setup { ensure_installed = { unpack(vim.tbl_keys(servers)), 'rust-analyzer' } }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  if name ~= 'rust-analyzer' then vim.lsp.enable(name) end
end

-- ── Formatting (conform.nvim) ─────────────────────────────────────────────
vim.pack.add { Gh 'stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Add filetypes here to enable format-on-save for them:
    local enabled = {
      lua = true,
      python = true,
    }
    if enabled[vim.bo[bufnr].filetype] then return { timeout_ms = 500 } end
  end,
  default_format_opts = {
    lsp_format = 'fallback', -- Use external formatters first, fall back to LSP
  },
  formatters_by_ft = {
    -- python = { 'isort', 'black' },
    -- javascript = { 'prettierd', 'prettier', stop_after_first = true },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = 'Show line [D]iagnostics' })

-- ── Snippets (LuaSnip) ────────────────────────────────────────────────────
vim.pack.add { { src = Gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

-- Uncomment to load friendly-snippets:
-- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
-- require('luasnip.loaders.from_vscode').lazy_load()

-- ── Completion (blink.cmp) ────────────────────────────────────────────────
vim.pack.add { { src = Gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = {
    ['<Tab>'] = { 'accept', 'fallback' },
  },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },
  sources = { default = { 'lsp', 'path', 'snippets' } },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}
