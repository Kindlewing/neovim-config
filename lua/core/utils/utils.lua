_G.neovim = {}

local stdpath = vim.fn.stdpath
neovim.compile_path = stdpath "data" .. "/packer_compiled.lua"
neovim.file_plugins = {}

function neovim.bootstrap()
  local fn = vim.fn
  local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    }
    print "Cloning packer...\nSetup AstroVim"
    vim.cmd [[packadd packer.nvim]]
  end
end


function neovim.default_tbl(opts, default)
    opts = opts or {}
    return default and vim.tbl_deep_extend("force", default, opts) or opts
end

function neovim.which_key_register(mappings, opts)
    local status_ok, which_key = pcall(require, "which-key")
    if not status_ok then return end
    for mode, prefixes in pairs(mappings) do
        for prefix, mapping_table in pairs(prefixes) do
            which_key.register(
                mapping_table,
                neovim.default_tbl(opts, {
                    mode = mode,
                    prefix = prefix,
                    buffer = nil,
                    silent = true,
                    noremap = true,
                    nowait = true,
                })
            )
        end
    end
end

function neovim.is_available(plugin)
    if _G.packer_plugins[plugin] and _G.packer_plugins[plugin].loaded then
        return true
    end
    return false
end

function neovim.initialize_packer()
    local util = require('packer.util')
    require('packer').init({
        ensure_dependencies  = true, -- Should packer install plugin dependencies?
        snapshot             = nil, -- Name of the snapshot you would like to load at startup
        snapshot_path        = util.join_paths(stdpath 'cache', 'packer.nvim'), -- Default save directory for snapshots
        package_root         = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack'),
        compile_path         = util.join_paths(vim.fn.stdpath('config'), 'lua', 'packer_compiled.lua'),
        plugin_package       = 'packer', -- The default package for plugins
        max_jobs             = nil, -- Limit the number of simultaneous jobs. nil means no limit
        auto_clean           = true, -- During sync(), remove unused plugins
        compile_on_sync      = true, -- During sync(), run packer.compile()
        disable_commands     = false, -- Disable creating commands
        opt_default          = false, -- Default to using opt (as opposed to start) plugins
        transitive_opt       = true, -- Make dependencies of opt plugins also opt by default
        transitive_disable   = true, -- Automatically disable dependencies of disabled plugins
        auto_reload_compiled = true, -- Automatically reload the compiled file after creating it.
        preview_updates      = false, -- If true, always preview updates before choosing which plugins to update, same as `PackerUpdate --preview`.
        git                  = {
            cmd = 'git', -- The base command for git operations
            subcommands = { -- Format strings for git subcommands
                update         = 'pull --ff-only --progress --rebase=false',
                install        = 'clone --depth %i --no-single-branch --progress',
                fetch          = 'fetch --depth 999999 --progress',
                checkout       = 'checkout %s --',
                update_branch  = 'merge --ff-only @{u}',
                current_branch = 'branch --show-current',
                diff           = 'log --color=never --pretty=format:FMT --no-show-signature HEAD@{1}...HEAD',
                diff_fmt       = '%%h %%s (%%cr)',
                get_rev        = 'rev-parse --short HEAD',
                get_msg        = 'log --color=never --pretty=format:FMT --no-show-signature HEAD -n 1',
                submodules     = 'submodule update --init --recursive --progress'
            },
            depth = 1, -- Git clone depth
            clone_timeout = 60, -- Timeout, in seconds, for git clones
            default_url_format = 'https://github.com/%s' -- Lua format string used for "aaa/bbb" style plugins
        },
        display              = {
            non_interactive = false, -- If true, disable display windows for all operations
            compact         = false, -- If true, fold updates results by default
            open_fn         = nil, -- An optional function to open a window for packer's display
            open_cmd        = '65vnew \\[packer\\]', -- An optional command to open a window for packer's display
            working_sym     = '⟳', -- The symbol for a plugin being installed/updated
            error_sym       = '✗', -- The symbol for a plugin with an error in installation/updating
            done_sym        = '✓', -- The symbol for a plugin which has completed installation/updating
            removed_sym     = '-', -- The symbol for an unused plugin which was removed
            moved_sym       = '→', -- The symbol for a plugin which was moved (e.g. from opt to start)
            header_sym      = '━', -- The symbol for the header line in packer's display
            show_all_info   = true, -- Should packer show all update details automatically?
            prompt_border   = 'double', -- Border style of prompt popups.
            keybindings     = { -- Keybindings for the display window
                quit = 'q',
                toggle_update = 'u', -- only in preview
                continue = 'c', -- only in preview
                toggle_info = '<CR>',
                diff = 'd',
                prompt_revert = 'r',
            }
        },
        luarocks             = {
            python_cmd = 'python' -- Set the python command to use for running hererocks
        },
        log                  = { level = 'warn' }, -- The default print log level. One of: "trace", "debug", "info", "warn", "error", "fatal".
        profile              = {
            enable = false,
            threshold = 1, -- integer in milliseconds, plugins which load faster than this won't be shown in profile output
        },
        autoremove           = false, -- Remove disabled or unused plugins without prompting the user
    })
end

function neovim.set_keymaps(map_table, base_options)
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
                vim.keymap.set(mode, keymap, cmd, keymap_opts)
            end
        end
    end
end


function neovim.lazy_load_commands(plugin, commands)
  if type(commands) == "string" then commands = { commands } end
  if neovim.is_available(plugin) and not packer_plugins[plugin].loaded then
    for _, command in ipairs(commands) do
      pcall(
        vim.cmd,
        string.format(
          'command -nargs=* -range -bang -complete=file %s lua require("packer.load")({"%s"}, { cmd = "%s", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)',
          command,
          plugin,
          command
        )
      )
    end
  end
end


function neovim.nav_buf(n)
  local current = vim.api.nvim_get_current_buf()
  for i, v in ipairs(vim.t.bufs) do
    if current == v then
      vim.cmd.b(vim.t.bufs[(i + n - 1) % #vim.t.bufs + 1])
      break
    end
  end
end


function neovim.close_buf(bufnr, force)
  if force == nil then force = false end
  local current = vim.api.nvim_get_current_buf()
  if not bufnr or bufnr == 0 then bufnr = current end
  if bufnr == current then neovim.nav_buf(-1) end

  if neovim.is_available "bufdelete.nvim" then
    require("bufdelete").bufdelete(bufnr, force)
  else
    vim.cmd((force and "bd!" or "confirm bd") .. bufnr)
  end
end


return neovim
