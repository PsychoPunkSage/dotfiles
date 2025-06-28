return {
  -- 'shaunsingh/nord.nvim',
  -- lazy = false,
  -- priority = 1000,
  -- config = function()
  --     -- Example config in lua
  --     vim.g.nord_contrast = true
  --     vim.g.nord_borders = false
  --     vim.g.nord_disable_background = true
  --     vim.g.nord_italic = false
  --     vim.g.nord_uniform_diff_background = true
  --     vim.g.nord_bold = false
  --
  --     -- Load the colorscheme
  --     require('nord').set()

  --
  -- -- Toggle background transparency
  -- local bg_transparent = true
  --
  -- local toggle_transparency = function()
  --   bg_transparent = not bg_transparent
  --   vim.g.nord_disable_background = bg_transparent
  --   vim.cmd [[colorscheme nord]]
  -- end

  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- Tokyo Night configuration
    require('tokyonight').setup {
      style = 'night',        -- The theme comes in four styles, `storm`, `moon`, a darker variant `night` and `day`
      transparent = true,     -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = {},
        variables = {},
        sidebars = 'dark', -- style for sidebars, see below
        floats = 'dark',   -- style for floating windows
      },
    }

    -- Load the colorscheme
    vim.cmd [[colorscheme tokyonight]]

    -- Toggle background transparency
    local bg_transparent = true

    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      require('tokyonight').setup {
        transparent = bg_transparent,
      }
      vim.cmd [[colorscheme tokyonight]]
    end

    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end,
}
