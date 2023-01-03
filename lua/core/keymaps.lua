local opts = { noremap=true, silent=true }
local builtin = require('telescope.builtin')


vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', opts)
vim.keymap.set('n', '<S-l>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-h>', ':bprev<CR>', opts)
vim.keymap.set('n', '<leader>c', ':bdelete<CR>', opts)
vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', opts)

-- Telescope
vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, opts)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, opts)
vim.keymap.set('n', '<leader>fh', builtin.help_tags, opts)
vim.keymap.set('n', '<leader>lD', function() builtin.diagnostics() end, opts)

-- NvimTree
vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<CR>')
