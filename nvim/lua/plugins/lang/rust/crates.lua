return {
  'saecki/crates.nvim',
  ft = { 'toml' },
  config = function()
    require('crates').setup {
      completion = {
        cmp = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    }
    require('cmp').setup.buffer {
      sources = { { name = 'crates' } },
    }

    -- Crates keymaps, buffer-local to Cargo.toml files
    local crates_augroup = vim.api.nvim_create_augroup('CratesConfig', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = crates_augroup,
      pattern = 'toml',
      callback = function(event)
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = event.buf, silent = true, desc = desc })
        end
        local crates = require 'crates'

        map('n', '<leader>ct', crates.toggle, 'Crates: Toggle')
        map('n', '<leader>cr', crates.reload, 'Crates: Reload')
        map('n', '<leader>cv', crates.show_versions_popup, 'Crates: Show Versions')
        map('n', '<leader>cf', crates.show_features_popup, 'Crates: Show Features')
        map('n', '<leader>cd', crates.show_dependencies_popup, 'Crates: Show Dependencies')
        map('n', '<leader>cu', crates.update_crate, 'Crates: Update Crate')
        map('v', '<leader>cu', crates.update_crates, 'Crates: Update Crates')
        map('n', '<leader>ca', crates.update_all_crates, 'Crates: Update All')
        map('n', '<leader>cU', crates.upgrade_crate, 'Crates: Upgrade Crate')
        map('v', '<leader>cU', crates.upgrade_crates, 'Crates: Upgrade Crates')
        map('n', '<leader>cA', crates.upgrade_all_crates, 'Crates: Upgrade All')
      end,
    })
  end,
}
