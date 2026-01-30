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
      tools = {
        hover_actions = {
          replace_builtin_hover = false, -- Don't auto-set K mapping, we handle it in on_attach
        },
      },
      server = {
        on_attach = function(client, bufnr)
          -- Set up K for Rust hover with actions (buffer-local)
          -- This replaces the generic LSP hover with Rust-enhanced hover
          vim.keymap.set('n', 'K', function()
            vim.cmd.RustLsp { 'hover', 'actions' }
          end, { buffer = bufnr, desc = 'Rust: Hover Actions' })
        end,
        default_settings = {
          ['rust-analyzer'] = {
            serverPath = (function()
              local wrapper = vim.fn.expand('~/.local/bin/rust-analyzer-limited')
              if vim.fn.executable(wrapper) == 1 then
                return wrapper
              end
              local cargo_ra = vim.fn.expand('~/.cargo/bin/rust-analyzer')
              if vim.fn.executable(cargo_ra) == 1 then
                return cargo_ra
              end
              return 'rust-analyzer'
            end)(),
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = {
              enable = true,
              allFeatures = true,
              command = 'clippy',
              extraArgs = { '--no-deps' },
            },
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
            -- Enhanced inlay hints
            inlayHints = {
              bindingModeHints = {
                enable = false,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              closureReturnTypeHints = {
                enable = 'never',
              },
              lifetimeElisionHints = {
                enable = 'never',
                useParameterNames = false,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = 'never',
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
          },
        },
      },
      -- DAP configuration
      dap = {
        adapter = require('rustaceanvim.config').get_codelldb_adapter(
          vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/adapter/codelldb',
          vim.fn.stdpath 'data' ..
          '/mason/packages/codelldb/extension/lldb/lib/liblldb' .. (vim.fn.has 'mac' == 1 and '.dylib' or '.so')
        ),
      },
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

    -- Unified language keybindings (same keys work in Go, Rust, etc.)
    map('n', '<Leader>lr', '<Cmd>RustLsp runnables<CR>', { desc = 'Run (Rust)' })
    map('n', '<Leader>ld', '<Cmd>RustLsp debuggables<CR>', { desc = 'Debug (Rust)' })
    map('n', '<Leader>lt', '<Cmd>RustLsp testables<CR>', { desc = 'Test (Rust)' })
    map('n', '<Leader>lT', '<Cmd>RustLsp testables<CR>', { desc = 'Test Function (Rust)' })
    map('n', '<Leader>re', '<Cmd>RustLsp expandMacro<CR>', { desc = 'Rust: Expand Macro' })
    map('n', '<Leader>rc', '<Cmd>RustLsp openCargo<CR>', { desc = 'Rust: Open Cargo.toml' })
    map('n', '<Leader>rp', '<Cmd>RustLsp parentModule<CR>', { desc = 'Rust: Parent Module' })
  end,
}
