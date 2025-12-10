return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        separator_style = 'slant',
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            text_align = 'left',
            highlight = 'Directory',
            separator = true, -- adds a visual separator
            padding = 1, -- horizontal padding around text
          },
          {
            filetype = 'neo-tree',
            text = 'Directory',
            text_align = 'center',
            highlight = 'Directory',
            separator = true,
            padding = 0,
          },
          {
            filetype = 'undotree',
            text = 'Undo Tree',
            text_align = 'center',
            highlight = 'Special',
            separator = true,
            padding = 1,
          },
        },
      },
    }
  end,
}
