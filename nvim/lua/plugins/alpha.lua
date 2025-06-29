return {
  'folke/snacks.nvim',
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        { section = 'keys',   gap = 1, padding = 1 },
        { section = 'startup' },
        {
          section = 'terminal',
          cmd = 'ascii-image-converter ~/.config/nvim/pfp.png -C -c',
          random = 10,
          pane = 2,
          indent = 4,
          height = 30,
        },
      },
    },
  },
}
