return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.config').setup {
      ensure_installed = { 'python', 'lua', 'vim', 'vimdoc', 'bash', 'c', 'c_sharp', 'cpp', 'java', 'rust' },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    }

    -- Force Tree-sitter to attach to existing and new buffers
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        if not vim.treesitter.highlighter.active[buf] then
          pcall(vim.treesitter.start, buf)
        end
      end,
    })
  end,
}
