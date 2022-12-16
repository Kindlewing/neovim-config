vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4;

vim.opt.copyindent = true -- Copy the previous indentation on autoindenting
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.fileencoding = "utf-8" -- File content encoding for the buffer
vim.opt.cmdheight = 0 -- hide command line unless needed
vim.opt.fillchars = { eob = " " } -- Disable `~` on nonexistent lines
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.lazyredraw = true -- lazily redraw screen
vim.opt.number = true -- Show numberline
vim.opt.preserveindent = true -- Preserve indent structure as much as possible
vim.opt.relativenumber = true -- Show relative numberline
vim.opt.swapfile = false -- Disable use of swapfile for the buffer
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.opt.timeoutlen = 300-- Length of time to wait for a mapped sequence
vim.opt.updatetime = 300 -- Length of time to wait before triggering the plugin
vim.opt.wrap = false -- Disable wrapping of lines longer than the width of window
vim.opt.writebackup = false -- Disable making a backup before overwriting a file
