-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Navigation: H/L for line start/end
vim.keymap.set("n", "H", "^", { desc = "Go to first non-whitespace character" })
vim.keymap.set("n", "L", "$", { desc = "Go to end of line" })

-- Search: Clear search highlighting
vim.keymap.set("n", "//", "<cmd>noh<cr>", { desc = "Clear search highlight" })

-- Editing: Visual mode indent without losing selection
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Files: Telescope file finder
vim.keymap.set("n", "<leader>p", function()
  require("lazyvim.util").pick("files")()
end, { desc = "Find files" })

-- Buffers: Alternate buffer
vim.keymap.set("n", "<leader><tab>", "<cmd>buffer #<cr>", { desc = "Alternate buffer" })

-- Windows: Toggle zoom
vim.keymap.set("n", "<leader>z", function()
  require("snacks").zen.zoom()
end, { desc = "Toggle zoom" })
