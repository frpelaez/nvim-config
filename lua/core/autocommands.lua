vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "c", "h", "cpp", "hpp" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.go", "*.rs", "*.py", "*.c", "*.h", "*.cpp", "*.hpp" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Fondo del menú (general)
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#ffffff", bold = true })

    vim.api.nvim_set_hl(0, "Pmenu", {
      bg = "#1e1e2e", -- Un fondo oscuro
      fg = "#cdd6f4", -- Texto claro
    })

    -- Elemento Seleccionado (importante para saber dónde estás)
    vim.api.nvim_set_hl(0, "PmenuSel", {
      bg = "#a594f9", -- Un color de contraste (ej. morado/azul)
      fg = "#1e1e2e", -- Texto oscuro para que se lea bien sobre el fondo claro
      bold = true,
    })

    -- Barra de desplazamiento (opcional)
    vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#1e1e2e" })
    vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#585b70" })

    vim.api.nvim_set_hl(0, "FidgetTask", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "FidgetTitle", { bg = "NONE" })
  end,
})
