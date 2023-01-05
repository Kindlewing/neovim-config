local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then impatient.enable_profile() end

require('core.utils.utils')
require('core.settings')
require('core.bootstrap')
require('core.keymaps')
require('core.plugin_config')
