local maps = { i = {}, n = {}, v = {}, t = {}, [""] = {} }
local opts = { noremap=true, silent=true }
maps.n['<leader>h']  = { ':nohlsearch<CR>' }

maps.n["<S-l>"] = { ':bnext<CR>', desc = 'Next buffer tab', opts }
maps.n["<S-h>"] = { ':bprev<CR>', desc = 'Previous buffer tab', opts }
maps.n[">b"] = { '<cmd>BufferLineMoveNext<CR>', desc = 'Move buffer tab right', opts }
maps.n["<b"] = { '<cmd>BufferLineMovePrev<CR>', desc = 'Move buffer tab left', opts }
