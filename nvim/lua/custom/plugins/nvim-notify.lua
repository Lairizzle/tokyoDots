return {
  'rcarriga/nvim-notify',
  config = function()
    local notify = require 'notify'

    notify.setup {
      -- Background color (get from current 'Normal' highlight or fallback)
      background_colour = '#000000',

      -- Notification stacking/animation
      stages = 'slide', -- Can be "fade", "slide", "fade_in_slide_out", etc.

      -- Duration before disappearing (ms)
      timeout = 3000,

      -- Whether to merge identical messages (like repeated LSP notices)
      merge = true,

      -- Deduplicate same messages
      merge_duplicates = true,

      -- Minimum/maximum notification width
      minimum_width = 20,
      max_width = 80,

      -- Display newest messages at the top
      top_down = true,

      -- Renderer style ("default", "minimal", etc.)
      render = 'default',
    }

    vim.notify = notify
  end,
}
