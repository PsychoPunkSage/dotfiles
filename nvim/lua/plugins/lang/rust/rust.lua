-- return {
--   'mrcjkb/rustaceanvim',
--   version = '^6', -- Recommended
--   lazy = false, -- This plugin is already lazy
--   dependencies = {
--     'williamboman/mason.nvim', -- Ensure Mason loads first
--   },
--   config = function()
--     local mason_registry = require('mason-registry')
--     local codelldb = mason_registry.get_package('codelldb')
--     local extension_path = codelldb:get_install_path() .. '/extension/'
--     local codelldb_path = extension_path .. 'adapter/codelldb'
--     local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
--     -- If you are on Linux, replace the line above with the line below:
--     -- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
--     local cfg = require 'rustaceanvim.config'
--
--     vim.g.rustaceanvim = {
--       dap = {
--         adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
--       },
--     }
--   end,
-- }

return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false,
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    -- Simple approach - let rustaceanvim auto-detect codelldb
    vim.g.rustaceanvim = {
      -- rustaceanvim will automatically find Mason-installed codelldb
      -- No manual path configuration needed
    }
    -- Rust-specific debug keymaps using rustaceanvim
    local map = vim.keymap.set
    map('n', '<Leader>dt', function()
      vim.cmd 'RustLsp testables'
    end, { desc = 'Debug: Rust Testables' })
    map('n', '<Leader>dR', function()
      vim.cmd 'RustLsp runnables'
    end, { desc = 'Debug: Rust Runnables' })
    map('n', '<Leader>drd', function()
      vim.cmd 'RustLsp debuggables'
    end, { desc = 'Debug: Rust Debuggables' })
  end,
}
