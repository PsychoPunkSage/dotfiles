return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_mappings_enabled = 0
    vim.g.vimtex_imaps_enabled = 0
    vim.g.vimtex_syntax_enabled = 1
    vim.g.vimtex_compiler_latexmk = {
      aux_dir = '.aux',
      out_dir = '',
      callback = 1,
      continuous = 1,
      executable = 'latexmk',
      hooks = {},
      options = {
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
      },
    }
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_toc_config = {
      split_pos = 'vert rightbelow',
      split_width = 35,
    }
  end,
  config = function()
    local latex_augroup = vim.api.nvim_create_augroup('LatexConfig', { clear = true })

    vim.api.nvim_create_autocmd('FileType', {
      group = latex_augroup,
      pattern = { 'tex', 'bib', 'plaintex' },
      callback = function()
        local opts = { buffer = true, silent = true }

        -- Unified language keybindings
        vim.keymap.set('n', '<leader>lb', '<cmd>VimtexCompile<cr>',
          vim.tbl_extend('force', opts, { desc = 'Compile (LaTeX)' }))
        vim.keymap.set('n', '<leader>lv', '<cmd>VimtexView<cr>',
          vim.tbl_extend('force', opts, { desc = 'View PDF (LaTeX)' }))
        vim.keymap.set('n', '<leader>le', '<cmd>VimtexErrors<cr>',
          vim.tbl_extend('force', opts, { desc = 'Show Errors (LaTeX)' }))

        -- LaTeX-specific commands
        vim.keymap.set('n', '<leader>xc', '<cmd>VimtexClean<cr>',
          vim.tbl_extend('force', opts, { desc = 'LaTeX Clean Aux' }))
        vim.keymap.set('n', '<leader>xt', '<cmd>VimtexTocToggle<cr>',
          vim.tbl_extend('force', opts, { desc = 'LaTeX Toggle TOC' }))
        vim.keymap.set('n', '<leader>xf', '<cmd>VimtexView<cr>',
          vim.tbl_extend('force', opts, { desc = 'LaTeX Forward Search' }))
        vim.keymap.set('n', '<leader>xi', '<cmd>VimtexStop<cr>',
          vim.tbl_extend('force', opts, { desc = 'LaTeX Stop Compilation' }))
        vim.keymap.set('n', '<leader>xl', '<cmd>VimtexCompileToggle<cr>',
          vim.tbl_extend('force', opts, { desc = 'LaTeX Toggle Continuous Compile' }))
        vim.keymap.set('n', '<leader>xC', '<cmd>VimtexCleanFull<cr>',
          vim.tbl_extend('force', opts, { desc = 'LaTeX Full Clean' }))
        vim.keymap.set('n', '<leader>xr', '<cmd>VimtexRefreshFolds<cr>',
          vim.tbl_extend('force', opts, { desc = 'LaTeX Refresh Folds' }))

        -- Word count
        vim.keymap.set('n', '<leader>xw', '<cmd>VimtexCountWords<cr>',
          vim.tbl_extend('force', opts, { desc = 'LaTeX Word Count' }))

        -- Buffer-local settings for LaTeX
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
        vim.opt_local.spelllang = 'en_us'
        vim.opt_local.conceallevel = 2
      end,
    })
  end,
  ft = { 'tex', 'bib', 'plaintex' },
}
