return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Dap UI setup
      dapui.setup()

      -- Minimal Virtual Text setup
      require('nvim-dap-virtual-text').setup {
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        show_stop_reason = true,
      }

      -- Configure Mason for DAP
      require('mason-nvim-dap').setup {
        ensure_installed = { 'codelldb' },
        automatic_installation = true,
      }

      -- Configure DAP adapters and configurations
      local mason_path = vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/'
      local codelldb_path = mason_path .. 'adapter/codelldb'

      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = codelldb_path,
          args = { '--port', '${port}' },
          detached = false,
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
          args = function()
            return vim.split(vim.fn.input 'Command-line arguments: ', ' ')
          end,
          runInTerminal = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- Custom icons
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#FF0000' }) -- Red coloring
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })

      -- Open DAP UI automatically when debugging starts
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Keybindings for debugging
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint' })
      vim.keymap.set('n', '<leader>gb', dap.run_to_cursor, { desc = 'Debug: Run to Cursor' })

      vim.keymap.set('n', '<F1>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F2>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F3>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F4>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<F5>', dap.step_back, { desc = 'Debug: Step Back' })
      vim.keymap.set('n', '<F10>', dap.restart, { desc = 'Debug: Restart' })
    end,
  },
}
