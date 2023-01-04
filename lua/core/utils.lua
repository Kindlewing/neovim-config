_G.neovim = {}

function neovim.is_available(plugin)
	return packer_plugins ~= nil and packer_plugins[plugin] ~= nil
end


return neovim
