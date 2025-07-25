return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      --'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      require('dapui').setup()
      --require('dap-go').setup()

      --config for C++
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          -- Update this path to where your codelldb executable is
          command = vim.fn.expand '~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb',
          args = { '--port', '${port}' },
        },
      }

      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},

          -- 💡 Optional: for showing disassembly if no source is available
          runInTerminal = false,
        },
      }

      --Config for Java
      dap.configurations.java = {
        {
          type = 'java',
          request = 'launch',
          name = 'Launch Java Program',
          mainClass = function()
            return vim.fn.input('Main Class > ', '', 'file')
          end,
          projectName = function()
            return vim.fn.input 'Project Name > '
          end,
        },
      }

      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)

      vim.keymap.set('n', '<F1>', dap.continue)
      vim.keymap.set('n', '<F2>', dap.step_into)
      vim.keymap.set('n', '<F3>', dap.step_over)
      vim.keymap.set('n', '<F4>', dap.step_out)
      vim.keymap.set('n', '<F5>', dap.step_back)
      vim.keymap.set('n', '<F13>', dap.restart)

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
