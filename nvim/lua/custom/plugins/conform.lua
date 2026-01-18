return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable autoformat for C# files to use CSharpier exclusively
      if vim.bo[bufnr].filetype == 'cs' then
        return { timeout_ms = 500, lsp_format = false }
      end
      -- Fallback to LSP formatting for other filetypes
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'black' },
      cs = { 'csharpier' },
    },
  },
}
