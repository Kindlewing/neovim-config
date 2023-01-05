local neovim_plugins = {
-- BEGIN PLUGINS
    ['wbthomason/packer.nvim'] = {
        setup = function()
            neovim.lazy_load_commands("packer.nvim", {
                "PackerSnapshot",
                "PackerSnapshotRollback",
                "PackerSnapshotDelete",
                "PackerInstall",
                "PackerUpdate",
                "PackerSync",
                "PackerClean",
                "PackerCompile",
                "PackerStatus",
                "PackerProfile",
                "PackerLoad",
              })
        end,
        config = function() require "core.plugins" end,
    },
    ['lewis6991/impatient.nvim'] = {},
    ['ellisonleao/gruvbox.nvim'] = {},
    ['nvim-tree/nvim-tree.lua'] = {},
    ["lukas-reineke/indent-blankline.nvim"] = {
        opt = true,
        setup = function() table.insert(neovim.file_plugins, "indent-blankline.nvim") end,
        config = function() require "core.plugin_config.indent-line" end,
    },
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
    ['nvim-treesitter/nvim-treesitter'] = {
        module = "nvim-treesitter",
        setup = function()
          table.insert(neovim.file_plugins, "nvim-treesitter")
          neovim.lazy_load_commands("nvim-treesitter", {
            "TSBufDisable",
            "TSBufEnable",
            "TSBufToggle",
            "TSDisable",
            "TSEnable",
            "TSToggle",
            "TSInstall",
            "TSInstallInfo",
            "TSInstallSync",
            "TSModuleInfo",
            "TSUninstall",
            "TSUpdate",
            "TSUpdateSync",
          })
        end,
        run = function() require("nvim-treesitter.install").update { with_sync = true }() end,
        config = function() require "core.plugin_config.treesitter" end,
    },
    ['hrsh7th/nvim-cmp'] = {},
    ['Darazaki/indent-o-matic'] = {
        opt = true,
        setup = {
            function()
                table.insert(neovim.file_plugins, 'indent-o-matic')
            end
        },
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

    ["famiu/bufdelete.nvim"] = {
        module = "bufdelete",
        setup = function() neovim.lazy_load_commands("bufdelete.nvim", { "Bdelete", "Bwipeout" }) end,
    },
    ['L3MON4D3/LuaSnip'] = { tag = "v<CurrentMajor>.*" },
    ['windwp/nvim-ts-autotag'] = { after = 'nvim-treesitter' },
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


local user_plugin_opts = neovim.user_plugin_opts
local status_ok, packer = pcall(require, "packer")
if status_ok then
  packer.startup {
    function(use)
      local plugins = user_plugin_opts("plugins.init", neovim_plugins)
      for key, plugin in pairs(plugins) do
        if type(key) == "string" and not plugin[1] then plugin[1] = key end
        if key == "williamboman/mason.nvim" and plugin.cmd then
          for mason_plugin, commands in pairs { -- lazy load mason plugin commands with Mason
            ["jayp0521/mason-null-ls.nvim"] = { "NullLsInstall", "NullLsUninstall" },
            ["williamboman/mason-lspconfig.nvim"] = { "LspInstall", "LspUninstall" },
            ["jayp0521/mason-nvim-dap.nvim"] = { "DapInstall", "DapUninstall" },
          } do
            if plugins[mason_plugin] and not plugins[mason_plugin].disable then
              vim.list_extend(plugin.cmd, commands)
            end
          end
        end
        use(plugin)
      end
    end,
    config = user_plugin_opts("plugins.packer", {
      compile_path = neovim.default_compile_path,
      display = {
        open_fn = function() return require("packer.util").float { border = "rounded" } end,
      },
      profile = {
        enable = true,
        threshold = 0.0001,
      },
      git = {
        clone_timeout = 300,
        subcommands = {
          update = "pull --rebase",
        },
      },
      auto_clean = true,
      compile_on_sync = true,
    }),
  }
end
