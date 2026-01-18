return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Package manager for LSP servers, formatters, and linters
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- LSP progress notifications in the bottom-right corner
    { 'j-hui/fidget.nvim', opts = {} },

    -- Completion plugin that provides LSP capabilities
    'saghen/blink.cmp',
  },

  config = function()
    -- ========================================================================
    -- LSP ATTACH CONFIGURATION
    -- ========================================================================
    -- This autocmd runs whenever an LSP server attaches to a buffer
    -- It sets up keymaps and features that are specific to LSP functionality
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        -- Helper function to create LSP keymaps with consistent options
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, {
            buffer = event.buf,
            desc = 'LSP: ' .. desc,
          })
        end

        -- Navigation keymaps (all start with 'gr' for "go/reference")
        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Symbol search keymaps
        map('gO', require('telescope.builtin').lsp_document_symbols, '[O]pen Document Symbols')
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace Symbols')

        -- Code action keymaps
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })

        -- Version-compatible helper to check if LSP supports a method
        -- Neovim 0.11 changed the API signature for this function
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
          return
        end

        -- Document highlight: Highlights other occurrences of the word under cursor
        -- when you pause (CursorHold event fires after 'updatetime' ms)
        if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })

          -- Highlight references when cursor stops moving
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })

          -- Clear highlights when cursor moves
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
          })

          -- Clean up when LSP detaches from buffer
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(detach_event)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds {
                group = 'lsp-highlight',
                buffer = detach_event.buf,
              }
            end,
          })
        end

        -- Inlay hints: Show type annotations and parameter names inline
        -- (e.g., showing variable types in Rust or parameter names in function calls)
        if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- ========================================================================
    -- DIAGNOSTIC CONFIGURATION
    -- ========================================================================
    -- Customize how diagnostics (errors, warnings, etc.) are displayed
    vim.diagnostic.config {
      -- Sort diagnostics by severity (errors first, then warnings, etc.)
      severity_sort = true,

      -- Floating window style when viewing diagnostic details
      float = {
        border = 'rounded',
        source = 'if_many', -- Show source if multiple sources exist
      },

      -- Only underline errors (not warnings/hints)
      underline = {
        severity = vim.diagnostic.severity.ERROR,
      },

      -- Custom icons in the sign column (gutter)
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},

      -- Virtual text appears at the end of lines with issues
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        -- Custom formatting for virtual text (currently just shows message)
        format = function(diagnostic)
          return diagnostic.message
        end,
      },
    }

    -- ========================================================================
    -- LSP CAPABILITIES
    -- ========================================================================
    -- Extend Neovim's default LSP capabilities with blink.cmp features
    -- This tells LSP servers what features our client supports (e.g., snippets)
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- ========================================================================
    -- LSP SERVERS
    -- ========================================================================
    -- Define which language servers to install and their configurations
    local servers = {
      -- C# Language Server
      csharp_ls = {},

      -- Python Language Server
      pyright = {},

      -- Lua Language Server (configured for Neovim development)
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace', -- Replace function signature on completion
            },
            diagnostics = {
              disable = { 'missing-fields' }, -- Don't warn about missing fields
            },
          },
        },
      },
    }

    -- ========================================================================
    -- MASON SETUP
    -- ========================================================================
    -- Ensure these tools are installed via Mason
    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, {
      'stylua', -- Lua formatter
      'black', -- Python formatter
      'csharpier', -- C# formatter
    })

    require('mason-tool-installer').setup {
      ensure_installed = ensure_installed,
    }

    -- Configure mason-lspconfig to automatically set up LSP servers
    require('mason-lspconfig').setup {
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = false,

      -- Handler function runs for each installed server
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}

          -- Merge server-specific capabilities with our enhanced capabilities
          -- This allows per-server customization while keeping blink.cmp features
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

          -- Initialize the LSP server with its configuration
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
