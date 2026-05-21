vim.pack.add { {
  src = 'https://github.com/mrcjkb/rustaceanvim',
  version = vim.version.range '^9',
} }

vim.g.rustaceanvim = {
  server = {
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
          buildScripts = { enable = true },
        },
        check = {
          command = 'clippy',
        },
        procMacro = {
          enable = true,
        },
        files = {
          watcher = 'server',
        },
      },
    },
  },
}
