return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- Formatters & linters for mason to install
    require('mason-null-ls').setup {
      ensure_installed = {
        'prettier', -- ts/js formatter
        'stylua', -- lua formatter
        'eslint_d', -- ts/js linter
        'shfmt', -- Shell formatter
        'checkmake', -- linter for Makefiles
        'ruff', -- Python linter and formatter
        'gofumpt', -- Better Go formatter (replaces gofmt)
        'goimports', -- Go imports organizer
        'golangci-lint', -- Go comprehensive linter
        'golines', -- Go line length formatter
        'rustfmt', -- Rust formatter
        -- 'black', -- another python linter and formatter
      },
      automatic_installation = true,
    }

    local sources = {
      -- General linters
      diagnostics.checkmake,

      -- Formatters
      formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
      formatting.stylua,
      formatting.shfmt.with { args = { '-i', '4' } },
      formatting.terraform_fmt,

      -- Python formatting and linting
      require 'none-ls.formatting.ruff_format',
      require('none-ls.diagnostics.ruff').with { extra_args = { '--extend-select', 'I' } },
      -- formatting.black, -- just formatting

      -- Go formatting and linting
      formatting.gofumpt,
      formatting.goimports, -- Organize imports
      -- Optional: golines for line length management
      formatting.golines.with {
        extra_args = { '--max-len=120', '--base-formatter=gofumpt' },
      },
      -- Go linting (alternative to gopls built-in linting)
      diagnostics.golangci_lint.with {
        extra_args = { '--fast' }, -- Faster linting
      },
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              if vim.bo[bufnr].filetype == 'go' then
                return
              end
              vim.lsp.buf.format {
                async = false,
                filter = function(c)
                  return c.name == 'null-ls'
                end,
              }
            end,
          })
        end
      end,
    }
  end,
}
