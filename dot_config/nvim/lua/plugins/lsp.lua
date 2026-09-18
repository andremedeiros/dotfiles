return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Disable inlay hints (e.g. gopls variable type hints) by default.
      -- Toggle per-buffer with <leader>uh.
      inlay_hints = { enabled = false },
    },
  },
}
