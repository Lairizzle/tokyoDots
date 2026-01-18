return {
  "nvim-java/nvim-java",
  config = false,
  setup = {
    jdtls = function()
      require("java").setup({})
    end,
  },
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          -- Your JDTLS configuration goes here
          jdtls = {
            handlers = {
              ["language/status"] = function(_, result)
                -- Print or whatever.
              end,
              ["$/progress"] = function(_, result, ctx)
                -- disable progress updates.
              end,
            },
          },
        },
      },
    },
  },
}
