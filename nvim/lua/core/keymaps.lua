-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>fn', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize +2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize -2<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>bd', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>bn', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigate between splits/tmux panes: see plugins.tmux-navigator

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>qd', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>ql', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Avante keymaps
vim.keymap.set('n', '<leader>aa', '<cmd>AvanteAsk<cr>', { desc = 'Avante Ask' })
vim.keymap.set('v', '<leader>ae', '<cmd>AvanteEdit<cr>', { desc = 'Avante Edit' })
vim.keymap.set('n', '<leader>at', '<cmd>AvanteToggle<cr>', { desc = 'Avante Toggle' })

-- Line duplication (VS Code-style with Alt+Shift)
-- Duplicate line/selection down
vim.keymap.set('n', '<M-S-j>', ':t.<CR>', { noremap = true, silent = true, desc = 'Duplicate line down' })
vim.keymap.set('v', '<M-S-j>', ":t'><CR>gv", { noremap = true, silent = true, desc = 'Duplicate selection down' })

-- Duplicate line/selection up
vim.keymap.set('n', '<M-S-k>', ':t.-1<CR>', { noremap = true, silent = true, desc = 'Duplicate line up' })
vim.keymap.set('v', '<M-S-k>', ":t'<-1<CR>gv", { noremap = true, silent = true, desc = 'Duplicate selection up' })

-- Line moving (VS Code-style with Alt+j/k)
-- Move line/selection down
vim.keymap.set('n', '<M-j>', ':m .+1<CR>==', { noremap = true, silent = true, desc = 'Move line down' })
vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = 'Move selection down' })

-- Move line/selection up
vim.keymap.set('n', '<M-k>', ':m .-2<CR>==', { noremap = true, silent = true, desc = 'Move line up' })
vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = 'Move selection up' })
