return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      -- Setup DAP UI
      ui.setup()

      -- Configure codelldb Adapter
      dap.adapters.codelldb = {
        type = 'executable',
        command = vim.fn.expand '~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb',
        options = {
          initialize_timeout_sec = 20,
        },
      }

      -- *** CORRECTED: Add Rust Configuration ***
      dap.configurations.rust = {
        {
          type = 'codelldb',
          request = 'launch',
          name = 'Run program',
          program = function()
            -- 1. Get absolute path of the current file
            local file = vim.fn.expand '%:p'

            -- 2. Get the directory of the current file
            local file_dir = vim.fn.fnamemodify(file, ':h')

            -- 3. Get the PROJECT ROOT (parent of src directory)
            -- This is where Cargo.toml lives, and where 'target/' is created
            local project_root = vim.fn.fnamemodify(file_dir, ':h')

            -- 4. Get the PROJECT NAME (This replaces 'main' with 'hello_world')
            -- For 'cargo new', the project folder name matches the binary name
            local project_name = vim.fn.fnamemodify(project_root, ':t')

            -- 5. Construct the full path
            return project_root .. '/target/debug/' .. project_name
          end,
          cwd = vim.fn.getcwd(),
          args = {},
        },
      }

      -- Keymaps
      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor)
      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)
      vim.keymap.set('n', '<F1>', dap.continue)
      vim.keymap.set('n', '<F2>', dap.step_into)
      vim.keymap.set('n', '<F3>', dap.step_over)
      vim.keymap.set('n', '<F4>', dap.step_out)
      vim.keymap.set('n', '<F5>', dap.step_back)
      vim.keymap.set('n', '<F13>', dap.restart)
      vim.keymap.set('n', '<leader>dc', require('dapui').close)

      -- Auto open/close dap-ui
      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
