return {
  'lairizzle/jrun.nvim',
  config = function()
    vim.keymap.set('n', '<leader>jr', function()
      require('jrun').run()
    end, { desc = 'Run Java in floating terminal' })
  end,
}
