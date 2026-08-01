return {
  -- No external plugin needed: clangd (lsp.lua) + codelldb (dap.lua) do the
  -- heavy lifting. This is a lazy-loaded local "plugin" purely to host the
  -- unified <leader>l keymaps for C/C++, ft-gated like go.nvim and vimtex.
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/lang/cpp',
  name = 'cpp-lang-config',
  ft = { 'c', 'cpp' },
  config = function()
    local cpp_augroup = vim.api.nvim_create_augroup('CppConfig', { clear = true })

    local function compiler()
      return vim.bo.filetype == 'c' and 'gcc' or 'g++'
    end

    local function out_path()
      return vim.fn.stdpath 'cache' .. '/cpp-build/' .. vim.fn.expand '%:t:r'
    end

    local function build(extra_args)
      vim.fn.mkdir(vim.fn.stdpath 'cache' .. '/cpp-build', 'p')
      local file = vim.fn.expand '%'
      local out = out_path()
      local cmd = { compiler(), '-std=' .. (vim.bo.filetype == 'c' and 'c17' or 'c++17'), '-Wall', '-g', file, '-o', out }
      if extra_args then
        vim.list_extend(cmd, extra_args)
      end
      return vim.fn.system(cmd), out
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = cpp_augroup,
      pattern = { 'c', 'cpp' },
      callback = function()
        local opts = { buffer = true, silent = true }

        -- Unified language keybindings (same keys work in Go, Rust, LaTeX)
        vim.keymap.set('n', '<leader>lb', function()
          local err = build()
          if err ~= '' then
            vim.notify(err, vim.log.levels.ERROR, { title = 'C/C++ Build' })
          else
            vim.notify('Build succeeded', vim.log.levels.INFO, { title = 'C/C++ Build' })
          end
        end, vim.tbl_extend('force', opts, { desc = 'Build (C/C++)' }))

        vim.keymap.set('n', '<leader>lr', function()
          local err, out = build()
          if err ~= '' then
            vim.notify(err, vim.log.levels.ERROR, { title = 'C/C++ Build' })
            return
          end
          vim.cmd('botright split | terminal ' .. out)
        end, vim.tbl_extend('force', opts, { desc = 'Run (C/C++)' }))

        vim.keymap.set('n', '<leader>ld', function()
          local err, out = build { '-O0' }
          if err ~= '' then
            vim.notify(err, vim.log.levels.ERROR, { title = 'C/C++ Build' })
            return
          end
          require('dap').run {
            name = 'Launch file',
            type = 'codelldb',
            request = 'launch',
            program = out,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
          }
        end, vim.tbl_extend('force', opts, { desc = 'Debug (C/C++)' }))
      end,
    })
  end,
}
