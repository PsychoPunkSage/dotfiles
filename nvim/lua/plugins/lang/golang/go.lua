return {
  -- Go specific tooling and configuration
  'ray-x/go.nvim',
  dependencies = {
    'ray-x/guihua.lua', -- Required for go.nvim
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    -- Setup go.nvim with comprehensive configuration
    require('go').setup {
      -- Disable lsp config since we handle it in lsp.lua
      lsp_cfg = false,

      -- LSP settings
      lsp_keymaps = false, -- We handle keymaps in lsp.lua
      lsp_codelens = true,

      -- Diagnostic settings
      diagnostic = {
        hdlr = false, -- Use default diagnostic handler
        underline = true,
        virtual_text = { space = 0, prefix = '■' },
        signs = true,
        update_in_insert = false,
      },

      -- LSP inlay hints
      lsp_inlay_hints = {
        enable = true,
        -- Only show inlay hints for the current line
        only_current_line = false,
        -- Event which triggers a refresh of the inlay hints
        only_current_line_autocmd = 'CursorHold',
        -- whether to show variable name before type hints with the inlay hints or not
        show_variable_name = true,
        -- prefix for parameter hints
        parameter_hints_prefix = '󰊕 ',
        show_parameter_hints = true,
        -- prefix for all the other hints (type, chaining)
        other_hints_prefix = '=> ',
        -- whether to align to the length of the longest line in the file
        max_len_align = false,
        -- padding from the left if max_len_align is true
        max_len_align_padding = 1,
        -- whether to align to the extreme right or not
        right_align = false,
        -- padding from the right if right_align is true
        right_align_padding = 6,
        -- The color of the hints
        highlight = 'Comment',
      },

      -- Formatter settings
      goimports = 'gopls', -- Use gopls for imports
      gofmt = 'gofumpt',   -- Use gofumpt for better formatting
      fillstruct = 'gopls',

      -- Test settings
      test_runner = 'go', -- Use go test
      run_in_floaterm = false,

      -- DAP settings
      dap_debug = true,
      dap_debug_keymap = false, -- We handle DAP keymaps elsewhere
      dap_debug_gui = true,
      dap_debug_vt = true,      -- Virtual text for debugging

      -- Build tags
      build_tags = '',

      -- Textobjects
      textobjects = true,

      -- Auto format on save
      auto_format = true,
      auto_lint = true,

      -- Trouble integration
      trouble = true,

      -- Luasnip integration
      luasnip = true,
    }

    -- Auto commands for Go files
    local go_augroup = vim.api.nvim_create_augroup('GoConfig', { clear = true })

    -- Auto format on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = go_augroup,
      pattern = '*.go',
      callback = function()
        -- Organize imports and format
        require('go.format').goimports()
      end,
    })

    -- Go specific keymaps
    vim.api.nvim_create_autocmd('FileType', {
      group = go_augroup,
      pattern = 'go',
      callback = function()
        local opts = { buffer = true, silent = true }

        -- Unified language keybindings (same keys work in Go, Rust, etc.)
        vim.keymap.set('n', '<leader>lr', '<cmd>GoRun<cr>', vim.tbl_extend('force', opts, { desc = 'Run (Go)' }))
        vim.keymap.set('n', '<leader>lt', '<cmd>GoTest<cr>', vim.tbl_extend('force', opts, { desc = 'Test (Go)' }))
        vim.keymap.set('n', '<leader>lT', '<cmd>GoTestFunc<cr>',
          vim.tbl_extend('force', opts, { desc = 'Test Function (Go)' }))
        vim.keymap.set('n', '<leader>ld', '<cmd>GoDebug<cr>', vim.tbl_extend('force', opts, { desc = 'Debug (Go)' }))
        vim.keymap.set('n', '<leader>lb', '<cmd>GoBuild<cr>', vim.tbl_extend('force', opts, { desc = 'Build (Go)' }))

        -- Go-specific commands
        vim.keymap.set('n', '<leader>gc', '<cmd>GoCoverage<cr>', vim.tbl_extend('force', opts, { desc = 'Go Coverage' }))

        -- Go tools
        vim.keymap.set('n', '<leader>gi', '<cmd>GoImports<cr>', vim.tbl_extend('force', opts, { desc = 'Go Imports' }))
        vim.keymap.set('n', '<leader>gf', '<cmd>GoFmt<cr>', vim.tbl_extend('force', opts, { desc = 'Go Format' }))
        vim.keymap.set('n', '<leader>gl', '<cmd>GoLint<cr>', vim.tbl_extend('force', opts, { desc = 'Go Lint' }))

        -- Go generate and mod
        vim.keymap.set('n', '<leader>gg', '<cmd>GoGenerate<cr>', vim.tbl_extend('force', opts, { desc = 'Go Generate' }))
        vim.keymap.set('n', '<leader>gm', '<cmd>GoMod<cr>', vim.tbl_extend('force', opts, { desc = 'Go Mod' }))

        -- Go tags
        vim.keymap.set('n', '<leader>ga', '<cmd>GoAddTag<cr>', vim.tbl_extend('force', opts, { desc = 'Go Add Tags' }))
        vim.keymap.set('n', '<leader>gR', '<cmd>GoRmTag<cr>', vim.tbl_extend('force', opts, { desc = 'Go Remove Tags' }))

        -- Go fill struct
        vim.keymap.set('n', '<leader>gs', '<cmd>GoFillStruct<cr>',
          vim.tbl_extend('force', opts, { desc = 'Go Fill Struct' }))

        -- Interface implementation
        vim.keymap.set('n', '<leader>gI', '<cmd>GoImpl<cr>',
          vim.tbl_extend('force', opts, { desc = 'Go Implement Interface' }))

        -- Error handling
        vim.keymap.set('n', '<leader>ge', '<cmd>GoIfErr<cr>', vim.tbl_extend('force', opts, { desc = 'Go If Err' }))
      end,
    })

    -- Set up Go specific LSP settings
    local lspconfig = require 'lspconfig'
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Enhanced gopls configuration
    lspconfig.gopls.setup {
      capabilities = capabilities,
      settings = {
        gopls = {
          -- Analysis settings
          analyses = {
            unusedparams = true,
            unreachable = true,
            fillstruct = true,
            nonewvars = true,
            undeclaredname = true,
            unusedwrite = true,
            useany = true,
          },

          -- Code lens
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },

          -- Completion settings
          completeUnimported = true,
          usePlaceholders = true,
          deepCompletion = true,

          -- Inlay hints
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },

          -- Import organization
          gofumpt = true,

          -- Static check
          staticcheck = true,

          -- Experimental features
          experimentalPostfixCompletions = true,
          experimentalUseInvalidMetadata = true,
          experimentalWatchedFileDelay = '100ms',
        },
      },

      -- File watchers
      flags = {
        debounce_text_changes = 150,
      },

      -- Initialize options
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
      },
    }
  end,

  -- Lazy loading
  ft = { 'go', 'gomod', 'gowork', 'gotmpl' },
  build = ':lua require("go.install").update_all_sync()',
}
