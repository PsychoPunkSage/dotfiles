-- Standalone plugins with less than 10 lines of config go here
return {
  -- {
  --   -- Tmux & split window navigation
  --   'christoomey/vim-tmux-navigator',
  -- },
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  {
    -- Powerful Git integration for Vim
    'tpope/vim-fugitive',
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      spec = {
        { '<leader>l', group = 'Language actions (run/test/debug/build)' },
        { '<leader>d', group = 'Debug (DAP)' },
        { '<leader>q', group = 'Diagnostics' },
        { '<leader>g', group = 'Go extras' },
        { '<leader>c', group = 'Crates (Rust)' },
        { '<leader>r', group = 'Rust extras' },
        { '<leader>x', group = 'LaTeX extras' },
        { '<leader>u', group = 'UI toggles' },
        { '<leader>s', group = 'Search (Telescope)' },
        { '<leader>t', group = 'Tabs' },
        { '<leader>b', group = 'Buffers' },
      },
    },
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
}
