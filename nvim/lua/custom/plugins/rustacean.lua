return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  config = function()
    local dap = require 'dap'

    vim.g.rustaceanvim = {
      dap = {
        adapter = dap.adapters.codelldb, -- reuse the table you already defined
      },
    }
  end,
}
