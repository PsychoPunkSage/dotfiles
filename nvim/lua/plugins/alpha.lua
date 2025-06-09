return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.startify'

    -- Cache for ASCII art (persists during session)
    local cached_art = nil
    local cache_attempted = false

    -- Fallback ASCII art if generation fails
    local fallback_art = {
      [[                                                    ]],
      [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
      [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
      [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
      [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
      [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
      [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
      [[                                                    ]],
    }

    local function generate_ascii_art()
      -- Return cached result if available
      if cached_art then
        return cached_art
      end

      -- Don't attempt generation more than once per session
      if cache_attempted then
        return fallback_art
      end

      cache_attempted = true

      -- Configuration
      local image_path = vim.fn.expand '~/.config/nvim/pfp.png'
      local ascii_dimensions = '60x20' -- format: widthxheight

      -- Check if image file exists
      if vim.fn.filereadable(image_path) == 0 then
        vim.notify('Image not found: ' .. image_path, vim.log.levels.INFO)
        cached_art = fallback_art
        return cached_art
      end

      -- Check if ascii-image-converter is installed
      if vim.fn.executable 'ascii-image-converter' == 0 then
        vim.notify(
        'ascii-image-converter not installed. Install with: go install github.com/TheZoraiz/ascii-image-converter@latest',
          vim.log.levels.WARN)
        cached_art = fallback_art
        return cached_art
      end

      -- Generate ASCII art
      local cmd = {
        'ascii-image-converter',
        image_path,
        '-C',
        '--dimensions',
        ascii_dimensions,
      }

      vim.notify('Generating ASCII art from image...', vim.log.levels.INFO)
      local result = vim.fn.system(cmd)

      -- Check if command succeeded
      if vim.v.shell_error ~= 0 then
        vim.notify('Failed to generate ASCII art (exit code: ' .. vim.v.shell_error .. ')', vim.log.levels.ERROR)
        cached_art = fallback_art
        return cached_art
      end

      -- Process the result
      local lines = vim.split(result, '\n', { trimempty = true })

      -- Remove empty lines and add padding
      local processed_lines = {}
      table.insert(processed_lines, '') -- top padding

      for _, line in ipairs(lines) do
        if line:match '%S' then -- only add non-empty lines
          table.insert(processed_lines, line)
        end
      end

      table.insert(processed_lines, '') -- bottom padding

      -- Cache the successful result
      cached_art = processed_lines
      vim.notify('ASCII art generated successfully!', vim.log.levels.INFO)

      return cached_art
    end

    -- Function to refresh ASCII art (useful for testing)
    local function refresh_ascii_art()
      cached_art = nil
      cache_attempted = false
      dashboard.section.header.val = generate_ascii_art()
      alpha.redraw()
    end

    -- Create user command for manual refresh
    vim.api.nvim_create_user_command('AlphaRefreshArt', refresh_ascii_art, {
      desc = 'Refresh ASCII art in Alpha dashboard',
    })

    -- Set the header
    dashboard.section.header.val = generate_ascii_art()

    -- Optional: Add some custom styling
    dashboard.section.header.opts.hl = 'AlphaHeader'

    alpha.setup(dashboard.opts)

    -- Optional: Set up highlight group for the header
    vim.api.nvim_set_hl(0, 'AlphaHeader', {
      fg = '#7aa2f7', -- Nice blue color, adjust as needed
      bold = true,
    })
  end,
}
