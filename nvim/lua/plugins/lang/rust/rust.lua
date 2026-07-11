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
    -- Rust-specific keymaps, buffer-local (mirrors Go's FileType autocmd pattern)
    local rust_augroup = vim.api.nvim_create_augroup('RustConfig', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = rust_augroup,
      pattern = 'rust',
      callback = function(event)
        local opts = { buffer = event.buf, silent = true }

        -- Unified language keybindings (same keys work in Go, Rust, etc.)
        vim.keymap.set('n', '<leader>lr', '<Cmd>RustLsp runnables<CR>', vim.tbl_extend('force', opts, { desc = 'Run (Rust)' }))
        vim.keymap.set('n', '<leader>ld', '<Cmd>RustLsp debuggables<CR>', vim.tbl_extend('force', opts, { desc = 'Debug (Rust)' }))
        vim.keymap.set('n', '<leader>lt', '<Cmd>RustLsp testables<CR>', vim.tbl_extend('force', opts, { desc = 'Test (Rust)' }))
        vim.keymap.set('n', '<leader>lT', '<Cmd>RustLsp testables<CR>', vim.tbl_extend('force', opts, { desc = 'Test Function (Rust)' }))

        -- Rust-specific commands
        vim.keymap.set('n', '<leader>re', '<Cmd>RustLsp expandMacro<CR>', vim.tbl_extend('force', opts, { desc = 'Rust: Expand Macro' }))
        vim.keymap.set('n', '<leader>rc', '<Cmd>RustLsp openCargo<CR>', vim.tbl_extend('force', opts, { desc = 'Rust: Open Cargo.toml' }))
        vim.keymap.set('n', '<leader>rp', '<Cmd>RustLsp parentModule<CR>', vim.tbl_extend('force', opts, { desc = 'Rust: Parent Module' }))
      end,
    })
  end,
}
