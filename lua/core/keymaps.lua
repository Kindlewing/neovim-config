local builtin = require('telescope.builtin')
local maps = { i = {}, n = {}, v = {}, t = {}, [''] = {} }

-- Builtiun
maps.n['<leader>h'] = { '<cmd>nohlsearch<CR>', desc = 'No Highlight' }
maps.n['<leader>tf'] = { '<cmd>ToggleTerm direction=float<CR>', desc = 'ToggleTerm float'}
maps.n["<S-l>"] = { '<cmd>bnext<CR>', desc = 'Next buffer' }
maps.n["<S-h>"] = { '<cmd>bprevious<CR>', desc = 'Previous buffer' }
maps.n["<leader>c"] = { '<cmd>bdelete<CR>', desc = 'Close buffer'}


-- Telescope
maps.n['<leader>ff'] = { builtin.find_files, desc = 'Search files' }
maps.n['<leader>fo'] = { builtin.oldfiles, desc = 'Search history' }
maps.n ['<leader>fg'] = { builtin.live_grep, desc = 'Search words' }
maps.n['<leader>fh'] = { builtin.help_tags, desc = 'Search help' }
maps.n['<leader>lD'] = { function() builtin.diagnostics() end, desc = 'Search diagnostics'}
maps.n["<leader>gt"] = { function() require("telescope.builtin").git_status() end, desc = "Git status" }
maps.n["<leader>gb"] = { function() require("telescope.builtin").git_branches() end, desc = "Git branches" }
maps.n["<leader>gc"] = { function() require("telescope.builtin").git_commits() end, desc = "Git commits" }
maps.n["<leader>sk"] = { function() require("telescope.builtin").keymaps() end, desc = "Search keymaps" }
maps.n["<leader>sc"] = { function() require("telescope.builtin").commands() end, desc = "Search commands" }
maps.n["<leader>sb"] = { function() require("telescope.builtin").git_branches() end, desc = "Git branches" }
maps.n["<leader>sh"] = { function() require("telescope.builtin").help_tags() end, desc = "Search help" }
maps.n["<leader>sm"] = { function() require("telescope.builtin").man_pages() end, desc = "Search man" }
maps.n["<leader>sr"] = { function() require("telescope.builtin").registers() end, desc = "Search registers" }

-- GitSigns
if neovim.is_available('gitsigns.nvim') then
  maps.n["<leader>gj"] = { function() require("gitsigns").next_hunk() end, desc = "Next git hunk" }
  maps.n["<leader>gk"] = { function() require("gitsigns").prev_hunk() end, desc = "Previous git hunk" }
  maps.n["<leader>gl"] = { function() require("gitsigns").blame_line() end, desc = "View git blame" }
  maps.n["<leader>gp"] = { function() require("gitsigns").preview_hunk() end, desc = "Preview git hunk" }
  maps.n["<leader>gh"] = { function() require("gitsigns").reset_hunk() end, desc = "Reset git hunk" }
  maps.n["<leader>gr"] = { function() require("gitsigns").reset_buffer() end, desc = "Reset git buffer" }
  maps.n["<leader>gs"] = { function() require("gitsigns").stage_hunk() end, desc = "Stage git hunk" }
  maps.n["<leader>gu"] = { function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage git hunk" }
  maps.n["<leader>gd"] = { function() require("gitsigns").diffthis() end, desc = "View git diff" }
end

-- Packer
maps.n["<leader>pc"] = { "<cmd>PackerCompile<cr>", desc = "Packer Compile" }
maps.n["<leader>pi"] = { "<cmd>PackerInstall<cr>", desc = "Packer Install" }
maps.n["<leader>ps"] = { "<cmd>PackerSync<cr>", desc = "Packer Sync" }
maps.n["<leader>pS"] = { "<cmd>PackerStatus<cr>", desc = "Packer Status" }
maps.n["<leader>pu"] = { "<cmd>PackerUpdate<cr>", desc = "Packer Update" }


-- NvimTree
maps.n['<leader>e'] = { '<cmd>NvimTreeFindFileToggle<CR>', desc = 'Toggle explorer' }

-- LSP

neovim.set_keymaps(maps, opts)
