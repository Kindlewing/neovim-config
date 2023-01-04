local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }) vim.cmd [[packadd packer.nvim]] return true
    end
    return false
end

local packer_bootstrap = ensure_packer()




local neovim_plugins = {
-- BEGIN PLUGINS
    ['wbthomason/packer.nvim'] = {},
    ['lewis6991/impatient.nvim'] = {},
    ['ellisonleao/gruvbox.nvim'] = {},
    ['nvim-tree/nvim-tree.lua'] = {},
    ['folke/which-key.nvim'] = { module = 'which-key', config = function() require('core.plugin_config.which-key') end },
    ['nvim-tree/nvim-web-devicons'] = {},
    ['akinsho/toggleterm.nvim'] = {
        tag = '*',
        config = function()
            require("toggleterm").setup()
        end
    },
    ['stevearc/dressing.nvim'] = {
        config = function()
            require('core.plugin_config.dressing')
        end
    },
    ['nvim-treesitter/nvim-treesitter'] = {},
    ['hrsh7th/nvim-cmp'] = {},
    ['Darazaki/indent-o-matic'] = {
        config = function()
            require('core.plugin_config.indent-o-matic')
        end
    },
    ['hrsh7th/cmp-nvim-lsp'] = {},
    ['SmiteshP/nvim-navic'] = {
        requires = "neovim/nvim-lspconfig"
    },
    ['lewis6991/gitsigns.nvim'] = {},
    ['nvim-lua/lsp-status.nvim'] = {},
    ['rebelot/kanagawa.nvim'] = {},
    ['rebelot/heirline.nvim'] = {
        event = 'VimEnter',
        config = function()
            require 'core.plugin_config.heirline'
        end
    },
    ['L3MON4D3/LuaSnip'] = { tag = "v<CurrentMajor>.*" },
    ['windwp/nvim-ts-autotag'] = {},
    ['windwp/nvim-autopairs'] = {
        config = function()
            require("nvim-autopairs").setup {}
        end
    },
    ['williamboman/mason.nvim'] =  {},
    ['williamboman/mason-lspconfig.nvim'] = {},
    ['neovim/nvim-lspconfig'] = {},
    ['nvim-telescope/telescope.nvim'] = {
        tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    },
}
-- END PLUGINS
local is_ok, packer = pcall(require, 'packer')

if is_ok then
    packer.startup {
        function(use)
            for key, plugin in pairs(neovim_plugins) do
                if type(key) == 'string' and not  plugin[1] then plugin[1] = key end
                if key == 'williamboman/mason.nvim' and plugin.cmd then
                    for mason_plugin, commands in pairs {
                        ['williamboman/mason-lspconfig.nvim'] = { 'LSPInstall', 'LspUninstall' },
                    } do
                        if neovim_plugins[mason_plugin] then
                            vim.list_extend(plugin.cmd, commands)
                        end
                    end
                end
                use(plugin)
            end
        end,
    }
end
