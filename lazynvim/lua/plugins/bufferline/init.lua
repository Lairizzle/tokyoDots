return {
  "akinsho/bufferline.nvim",
  opts = function(_, opts)
    opts.options.offsets = {
      {
        filetype = "snacks_layout_box",
        text = "Current Directory",
        highlight = "Directory",
        text_align = "center",
      },
    }
  end,
}
