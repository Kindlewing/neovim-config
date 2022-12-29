local ensure_packer = function()
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'ellisonleao/gruvbox.nvim'
	use 'nvim-tree/nvim-tree.lua'
	use 'nvim-tree/nvim-web-devicons'
	use 'nvim-treesitter/nvim-treesitter'
	use 'mfussenegger/nvim-dap'
	use 'hrsh7th/nvim-cmp'
	use 'j-hui/fidget.nvim'
	use {
    	"SmiteshP/nvim-navic",
    	requires = "neovim/nvim-lspconfig"
	}
	use 'hrsh7th/cmp-nvim-lsp'
	use {
  	  'lewis6991/gitsigns.nvim'
	}
	use "rebelot/heirline.nvim"
	use({"L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*"})
	use 'windwp/nvim-ts-autotag'
	use {
		"windwp/nvim-autopairs",
    	config = function()
    		require("nvim-autopairs").setup {}
    	end
	}
	use {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
	}
	use {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.0',
		requires = {{ 'nvim-lua/plenary.nvim' }}
	}
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end)
