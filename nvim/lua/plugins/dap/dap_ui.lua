return {
  'rcarriga/nvim-dap-ui',
  dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'
    dapui.setup()

    -- DAP UI auto-open/close listeners
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- UI-specific keymaps
    local map = vim.keymap.set

    -- DAP UI controls (if you want them here)
    map('n', '<Leader>du', function()
      require('dapui').toggle()
    end, { desc = 'Debug: Toggle UI' })
    map('n', '<Leader>dE', function()
      require('dapui').eval()
    end, { desc = 'Debug: Eval Expression' })
  end,
}
