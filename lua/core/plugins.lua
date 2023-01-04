local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()


-- BEGIN PLUGINS
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'lewis6991/impatient.nvim'
    use 'ellisonleao/gruvbox.nvim'
    use 'nvim-tree/nvim-tree.lua'
    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }
use 'nvim-tree/nvim-web-devicons'
    use {
        "akinsho/toggleterm.nvim",
        tag = '*',
        config = function()
            require("toggleterm").setup()
        end
    }
    use {
        'stevearc/dressing.nvim',
        config = function()
            require('core.plugin_config.dressing')
        end
    }
    use 'nvim-treesitter/nvim-treesitter'
    use 'hrsh7th/nvim-cmp'
    use {
        'Darazaki/indent-o-matic',
        config = function()
            require('core.plugin_config.indent-o-matic')
        end
    }
    use 'hrsh7th/cmp-nvim-lsp'
    use {
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig"
    }
    use {
        'lewis6991/gitsigns.nvim'
    }
    use 'nvim-lua/lsp-status.nvim'
    use 'rebelot/kanagawa.nvim'
    use {
        'rebelot/heirline.nvim',
        event = 'VimEnter',
        config = function()
            require 'core.plugin_config.heirline'
        end
    }

    use({ "L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*" })
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
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    -- END PLUGINS

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
