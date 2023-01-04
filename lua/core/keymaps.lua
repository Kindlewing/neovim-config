local opts = { noremap=true, silent=true }
local builtin = require('telescope.builtin')
local map = vim.keymap.set
local maps = { i = {}, n = {}, v = {}, t = {} }


maps.n['<leader>h'] = { '<cmd>nohlsearch<CR>', desc = 'No Highlight' }
maps.n["<S-l>"] = { '<cmd>bnext<CR>', desc = 'Next buffer' }
maps.n["<S-h>"] = { '<cmd>bprevious<CR>', desc = 'Previous buffer' }
maps.n["<leader>c"] = { '<cmd>bdelete<CR>', desc = 'Close buffer'}

maps.n['<leader>tf'] = { '<cmd>ToggleTerm direction=float<CR>', desc = 'ToggleTerm float'}

-- Telescope
maps.n['<leader>ff'] = { builtin.find_files, desc = 'Search files' }
maps.n['<leader>fo'] = { builtin.oldfiles, desc = 'Search history' }
maps.n ['<leader>fg'] = { builtin.live_grep, desc = 'Search words' }
maps.n['<leader>fh'] = { builtin.help_tags, desc = 'Search help' }
maps.n['<leader>lD'] = { function() builtin.diagnostics() end, desc = 'Search diagnostics'}

-- NvimTree
maps.n['<leader>e'] = { '<cmd>NvimTreeFindFileToggle<CR>', desc = 'Toggle explorer' }


local function set_keymaps(map_table, base_options)
	for mode, maps in pairs(map_table) do
		for keymap, options in pairs(maps) do
			if options then
				local cmd = options
				local keymap_opts = base_options or {}
				if type(options) == 'table' then
					cmd = options[1]
					keymap_opts = vim.tbl_deep_extend('force', options, keymap_opts)
					keymap_opts[1] = nil
				end
				map(mode, keymap, cmd, keymap_opts)
			end
		end
	end
end

set_keymaps(maps)
