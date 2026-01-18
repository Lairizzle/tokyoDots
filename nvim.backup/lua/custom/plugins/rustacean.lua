return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  config = function()
    local dap = require 'dap'

    vim.g.rustaceanvim = {
      dap = {
        adapter = dap.adapters.codelldb,
      },
      server = {
        settings = {
          ['rust-analyzer'] = {
            checkOnSave = true,
            check = {
              command = 'clippy', -- or "check" if you stay on stable
            },
            inlayHints = {
              enable = true,
              typeHints = true,
              parameterHints = true,
              chainingHints = true,
            },
            hover = {
              actions = {
                enable = true,
              },
            },
            lens = {
              enable = true,
            },
          },
        },
      },
    }
  end,
}
