vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("file_plugin_lazy_load", { clear = true }),
  callback = function(args)
    if not (vim.fn.expand "%" == "" or vim.api.nvim_buf_get_option(args.buf, "buftype") == "nofile") then
      vim.api.nvim_del_augroup_by_name "file_plugin_lazy_load"
      local packer = require "packer"
      vim.tbl_map(function(plugin) packer.loader(plugin) end, neovim.file_plugins)
    end
  end,
})
