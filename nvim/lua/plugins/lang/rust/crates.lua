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

    -- Crates keymaps
    local map = vim.keymap.set
    map('n', '<leader>ct', require('crates').toggle, { desc = 'Crates: Toggle' })
    map('n', '<leader>cr', require('crates').reload, { desc = 'Crates: Reload' })
    map('n', '<leader>cv', require('crates').show_versions_popup, { desc = 'Crates: Show Versions' })
    map('n', '<leader>cf', require('crates').show_features_popup, { desc = 'Crates: Show Features' })
    map('n', '<leader>cd', require('crates').show_dependencies_popup, { desc = 'Crates: Show Dependencies' })
    map('n', '<leader>cu', require('crates').update_crate, { desc = 'Crates: Update Crate' })
    map('v', '<leader>cu', require('crates').update_crates, { desc = 'Crates: Update Crates' })
    map('n', '<leader>ca', require('crates').update_all_crates, { desc = 'Crates: Update All' })
    map('n', '<leader>cU', require('crates').upgrade_crate, { desc = 'Crates: Upgrade Crate' })
    map('v', '<leader>cU', require('crates').upgrade_crates, { desc = 'Crates: Upgrade Crates' })
    map('n', '<leader>cA', require('crates').upgrade_all_crates, { desc = 'Crates: Upgrade All' })
  end,
}
