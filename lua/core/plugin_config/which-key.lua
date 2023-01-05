require('which-key').setup({
	plugins = {
		spelling = { enabled = true },
		presets = { operators = false },
	},
	window = {
		border = "rounded",
		padding = { 2, 2, 2, 2 },
	},
	layout = {
		height = { min = 4, max = 25 },
		width = { min = 20, max = 50 },
		spacing = 8,
		align = 'left',
	},
	disable = { filetypes = { "TelescopePrompt" } },
})
