return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'williamboman/mason.nvim',
    'rcarriga/nvim-dap-ui',
  },
  config = function()
    -- local dap, dapui = require 'dap', require 'dapui'
    local dap = require 'dap'

    -- Configure CodeLLDB adapter for Rust
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        -- Get CodeLLDB path from Mason
        command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
        args = { '--port', '${port}' },
      },
    }

    -- Configure Delve adapter for GoLang
    dap.adapters.delve = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/bin/dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
      },
    }

    -- Configure Rust debugging
    dap.configurations.rust = {
      {
        name = 'Launch file',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
      {
        name = 'Launch file (with args)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
          local args_string = vim.fn.input 'Arguments: '
          return vim.split(args_string, ' ')
        end,
      },
    }

    -- Configure Golang debugging
    dap.configurations.go = {
      {
        type = 'delve',
        name = 'Debug',
        request = 'launch',
        program = '${file}',
      },
      {
        type = 'delve',
        name = 'Debug Package',
        request = 'launch',
        program = '${fileDirname}',
      },
      {
        type = 'delve',
        name = 'Debug test',
        request = 'launch',
        mode = 'test',
        program = '${file}',
      },
    }

    -- DAP Keymaps
    local map = vim.keymap.set

    -- Core DAP controls
    map('n', '<Leader>dl', function()
      require('dap').step_into()
    end, { desc = 'Debug: Step Into' })
    map('n', '<Leader>dj', function()
      require('dap').step_over()
    end, { desc = 'Debug: Step Over' })
    map('n', '<Leader>dk', function()
      require('dap').step_out()
    end, { desc = 'Debug: Step Out' })
    map('n', '<Leader>dc', function()
      require('dap').continue()
    end, { desc = 'Debug: Continue' })
    map('n', '<Leader>db', function()
      require('dap').toggle_breakpoint()
    end, { desc = 'Debug: Toggle Breakpoint' })
    map('n', '<Leader>dd', function()
      require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Conditional Breakpoint' })
    map('n', '<Leader>de', function()
      require('dap').terminate()
    end, { desc = 'Debug: Terminate' })
    map('n', '<Leader>dr', function()
      require('dap').run_last()
    end, { desc = 'Debug: Run Last' })
  end,
}
