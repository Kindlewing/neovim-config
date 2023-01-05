_G.neovim = {}

neovim.file_plugins = {}

local stdpath = vim.fn.stdpath
neovim.default_compile_path = stdpath "data" .. "packer_compiled.lua"

--- installation details from external installers
neovim.install = { home = stdpath "config" }
--- external astronvim configuration folder
neovim.install.config = stdpath("config"):gsub("nvim$", "astronvim")
vim.opt.rtp:append(neovim.install.config)
local supported_configs = { neovim.install.home, neovim.install.config }


--- Looks to see if a module path references a lua file in a configuration folder and tries to load it. If there is an error loading the file, write an error and continue
-- @param module the module path to try and load
-- @return the loaded module if successful or nil
local function load_module_file(module)
  -- placeholder for final return value
  local found_module = nil
  -- search through each of the supported configuration locations
  for _, config_path in ipairs(supported_configs) do
    -- convert the module path to a file path (example user.init -> user/init.lua)
    local module_path = config_path .. "/lua/" .. module:gsub("%.", "/") .. ".lua"
    -- check if there is a readable file, if so, set it as found
    if vim.fn.filereadable(module_path) == 1 then found_module = module_path end
  end
  -- if we found a readable lua file, try to load it
  if found_module then
    -- try to load the file
    local status_ok, loaded_module = pcall(require, module)
    -- if successful at loading, set the return variable
    if status_ok then
      found_module = loaded_module
      -- if unsuccessful, throw an error
    else
      vim.api.nvim_err_writeln("Error loading file: " .. found_module .. "\n\n" .. loaded_module)
    end
  end
  -- return the loaded module or nil if no file found
  return found_module
end




--- Main configuration engine logic for extending a default configuration table with either a function override or a table to merge into the default option
-- @function astronvim.func_or_extend
-- @param overrides the override definition, either a table or a function that takes a single parameter of the original table
-- @param default the default configuration table
-- @param extend boolean value to either extend the default or simply overwrite it if an override is provided
-- @return the new configuration table
local function func_or_extend(overrides, default, extend)
  -- if we want to extend the default with the provided override
  if extend then
    -- if the override is a table, use vim.tbl_deep_extend
    if type(overrides) == "table" then
      default = neovim.default_tbl(overrides, default)
      -- if the override is  a function, call it with the default and overwrite default with the return value
    elseif type(overrides) == "function" then
      default = overrides(default)
    end
    -- if extend is set to false and we have a provided override, simply override the default
  elseif overrides ~= nil then
    default = overrides
  end
  -- return the modified default table
  return default
end


--- Search the user settings (user/init.lua table) for a table with a module like path string
-- @param module the module path like string to look up in the user settings table
-- @return the value of the table entry if exists or nil
local function user_setting_table(module)
  -- get the user settings table
  local settings = neovim.user_settings or {}
  -- iterate over the path string split by '.' to look up the table value
  for tbl in string.gmatch(module, "([^%.]+)") do
    settings = settings[tbl]
    -- if key doesn't exist, keep the nil value and stop searching
    if settings == nil then break end
  end
  -- return the found settings
  return settings
end




--- User configuration entry point to override the default options of a configuration table with a user configuration file or table in the user/init.lua user settings
-- @param module the module path of the override setting
-- @param default the default settings that will be overridden
-- @param extend boolean value to either extend the default settings or overwrite them with the user settings entirely (default: true)
-- @param prefix a module prefix for where to search (default: user)
-- @return the new configuration settings with the user overrides applied
function neovim.user_plugin_opts(module, default, extend, prefix)
  -- default to extend = true
  if extend == nil then extend = true end
  -- if no default table is provided set it to an empty table
  default = default or {}
  -- try to load a module file if it exists
  local user_settings = load_module_file((prefix or "user") .. "." .. module)
  -- if no user module file is found, try to load an override from the user settings table from user/init.lua
  if user_settings == nil and prefix == nil then user_settings = user_setting_table(module) end
  -- if a user override was found call the configuration engine
  if user_settings ~= nil then default = func_or_extend(user_settings, default, extend) end
  -- return the final configuration table with any overrides applied
  return default
end





--- Check if packer is installed and loadable, if not then install it and make sure it loads
function neovim.initialize_packer()
  -- try loading packer
  local packer_path = stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
  local packer_avail = vim.fn.empty(vim.fn.glob(packer_path)) == 0
  -- if packer isn't availble, reinstall it
  if not packer_avail then
    -- set the location to install packer
    -- delete the old packer install if one exists
    vim.fn.delete(packer_path, "rf")
    -- clone packer
    vim.fn.system {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      packer_path,
    }
    -- add packer and try loading it
    vim.cmd.packadd "packer.nvim"
    local packer_loaded, _ = pcall(require, "packer")
    packer_avail = packer_loaded
    -- if packer didn't load, print error
    if not packer_avail then vim.api.nvim_err_writeln("Failed to load packer at:" .. packer_path) end
  end
  -- if packer is available, check if there is a compiled packer file
  if packer_avail then
    -- try to load the packer compiled file
    local run_me, _ = loadfile(
      neovim.user_plugin_opts("plugins.packer", { compile_path = neovim.default_compile_path }).compile_path
    )
    if run_me then
      -- if the file loads, run the compiled function
      run_me()
    else
      -- if there is no compiled file, ask user to sync packer
      require "core.plugins"
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "PackerComplete",
        callback = function()
          vim.cmd.bw()
          vim.tbl_map(require, { "nvim-treesitter", "mason" })
        end,
      })
      vim.opt.cmdheight = 1
      vim.cmd.PackerSync()
    end
  end
end



--- Merge extended options with a default table of options
-- @param opts the new options that should be merged with the default table
-- @param default the default table that you want to merge into
-- @return the merged table
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


return neovim
