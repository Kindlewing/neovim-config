require('nvim-treesitter.configs').setup {
	ensure_innstalled = { 'rust', 'php', 'vim' },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
	},
}
