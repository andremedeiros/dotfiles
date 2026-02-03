-- Disable yanky.nvim's <leader>p binding (yank history)
-- We use <leader>p for file finder instead
return {
  "gbprod/yanky.nvim",
  keys = {
    { "<leader>p", false },
  },
}
