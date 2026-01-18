return {
  'lairizzle/pyrun.nvim',
  config = function()
    vim.keymap.set('n', '<leader>pr', function()
      require('pyrun').run()
    end, { desc = 'Run Python in floating terminal' })
  end,
}
