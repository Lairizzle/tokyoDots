return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    routes = {
      {
        filter = {
          event = 'lsp',
          kind = 'progress',
          cond = function(message)
            local client = vim.tbl_get(message.opts, 'progress', 'client')
            if client ~= 'jdtls' then
              return false
            end

            local content = vim.tbl_get(message.opts, 'progress', 'message')
            if content == nil then
              return false
            end

            return string.find(content, 'Validate') or string.find(content, 'Publish')
          end,
        },
        opts = { skip = true },
      },
    },
    lsp = {
      signature = {
        enabled = false, -- <- this fully disables LSP signature popups from noice
        auto_open = { enabled = false },
      },
    },
    -- add any options here
    presets = {
      lsp_doc_border = true,
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    'rcarriga/nvim-notify',
  },
}
