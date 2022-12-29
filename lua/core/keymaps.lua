local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', opts)
vim.keymap.set('n', '<S-l>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-h>', ':bprev<CR>', opts)
vim.keymap.set('n', '<leader>c', ':bdelete<CR>', opts)
