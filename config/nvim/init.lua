require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- packer can manage itself
  use 'tpope/vim-fugitive' -- awesome git
  use 'nvim-lualine/lualine.nvim'
  use 'rhysd/vim-grammarous' -- grammar check
  use 'andymass/vim-matchup' -- matching parens and more
  use 'bronson/vim-trailing-whitespace' -- highlight trailing spaces
  use 'rhysd/git-messenger.vim'
  use { 'lewis6991/gitsigns.nvim', -- git added/removed in sidebar + inline blame
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup({
        current_line_blame = false
      })
    end
  }

  use {
    'lewis6991/spaceless.nvim',
    config = function()
      require'spaceless'.setup()
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'tpope/vim-vinegar'
  use 'mhinz/vim-startify'

  -- looks
  use 'nanotech/jellybeans.vim'

  -- general dev
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'neovim/nvim-lspconfig' -- all the languages
  use 'simrat39/symbols-outline.nvim'

  -- golang
  use {
    'ray-x/go.nvim',
    ft = 'go',
    config = function()
      require'go'.setup()
    end
  }
end)

HOME = os.getenv('HOME')
HOMEBREW = os.getenv('HOMEBREW_PREFIX')

-- backup / swap
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.cmd 'colorscheme jellybeans'

-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- ui
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.clipboard = 'unnamed'
vim.opt.splitbelow = true
vim.opt.splitright = true

-- whitespace
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- lsp
local lspconfig = require'lspconfig'
lspconfig.elixirls.setup{ cmd = {HOMEBREW .. "/opt/elixir-ls/bin/elixir-ls"} }
lspconfig.elmls.setup{}
lspconfig.eslint.setup{}
lspconfig.gopls.setup{}
lspconfig.html.setup{}
lspconfig.jsonls.setup{}
lspconfig.rust_analyzer.setup{}
lspconfig.solargraph.setup{}
lspconfig.sumneko_lua.setup{}
lspconfig.tsserver.setup{}

-- mappings
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

local function vmap(shortcut, command)
  map('v', shortcut, command)
end

local function cmap(shortcut, command)
  map('c', shortcut, command)
end

local function tmap(shortcut, command)
  map('t', shortcut, command)
end

nmap('H', '^')
nmap('L', '$')

nmap('<C-j>', '<C-w>j')
nmap('<C-k>', '<C-w>k')
nmap('<C-h>', '<C-w>h')
nmap('<C-l>', '<C-w>l')

nmap('<Leader>p', "<cmd>lua require('telescope.builtin').find_files()<cr>")
nmap('<Leader>gr', "<cmd>lua require('telescope.builtin').live_grep()<cr>")

vmap('<', '<gv')
vmap('>', '>gv')

nmap('<Leader>t', [[<cmd>SymbolsOutline<cr>]])
-- lualine
require('lualine').setup {
  extensions = { 'fugitive' }
}

-- golang
function org_imports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, 'utf-16')
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua org_imports(1000) ]], false) -- format on save
