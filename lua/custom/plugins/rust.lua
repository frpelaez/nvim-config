vim.pack.add { {
  src = 'https://github.com/mrcjkb/rustaceanvim',
  version = vim.version.range '^9',
} }

local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set('n', '<leader>a', function() vim.cmd.RustLsp 'codeAction' end, { silent = true, buffer = bufnr })

vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true },
        checkOnSave = false,
        check = {
          command = 'clippy',
          extraArgs = { '--', '-W', 'clippy::all' },
          workspace = false,
        },
        files = {
          watcher = 'server', -- 'server' (default 'client') puede ser más lento en Windows
        },
      },
    },
  },
}
