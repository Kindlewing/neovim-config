local is_available = neovim.is_available
local mappings = {
  n = {
    ["<leader>"] = {
      f = { name = "File" },
      p = { name = "Packages" },
      l = { name = "LSP" },
      u = { name = "UI" },
    },
  },
}

local extra_sections = {
  b = "Buffers",
  D = "Debugger",
  g = "Git",
  s = "Search",
  S = "Session",
  t = "Terminal",
}

local function init_table(mode, prefix, idx)
  if not mappings[mode][prefix][idx] then mappings[mode][prefix][idx] = { name = extra_sections[idx] } end
end

if is_available "heirline.nvim" and vim.g.heirline_bufferline then init_table("n", "<leader>", "b") end

if is_available "neovim-session-manager" then init_table("n", "<leader>", "S") end

if is_available "gitsigns.nvim" then init_table("n", "<leader>", "g") end

if is_available "toggleterm.nvim" then
  init_table("n", "<leader>", "g")
  init_table("n", "<leader>", "t")
end

if is_available "telescope.nvim" then
  init_table("n", "<leader>", "s")
  init_table("n", "<leader>", "g")
end

if is_available "nvim-dap" then init_table("n", "<leader>", "D") end
neovim.which_key_register(mappings)
