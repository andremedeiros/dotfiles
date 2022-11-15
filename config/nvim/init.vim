" Thanks @fatih for a lot of these.

" Preamble {{{
function! PackInit() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " language/syntax
  call minpac#add('ElmCast/elm-vim')
  call minpac#add('LnL7/vim-nix')
  call minpac#add('andremedeiros/ragel.vim')
  call minpac#add('fatih/vim-go')
  call minpac#add('isRuslan/vim-es6')
  call minpac#add('leafgarland/typescript-vim')
  call minpac#add('tmux-plugins/vim-tmux')
  call minpac#add('tomlion/vim-solidity')
  call minpac#add('vim-crystal/vim-crystal')
  call minpac#add('vim-ruby/vim-ruby')
  call minpac#add('ruby-formatter/rufo-vim')

  " colorschemes / ui
  call minpac#add('Xuyuanp/nerdtree-git-plugin')
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('mhinz/vim-startify')
  call minpac#add('nanotech/jellybeans.vim')
  call minpac#add('romainl/vim-qf')
  call minpac#add('scrooloose/nerdtree')
  call minpac#add('troydm/zoomwintab.vim')

  " file management / browsing
  call minpac#add('junegunn/fzf', { 'do': { -> fzf#install() } })
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('majutsushi/tagbar')
  call minpac#add('tmux-plugins/vim-tmux-focus-events')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-rhubarb')

  " helpers
  call minpac#add('editorconfig/editorconfig-vim')
  call minpac#add('liuchengxu/vista.vim')
  call minpac#add('prabirshrestha/async.vim')
  call minpac#add('prabirshrestha/vim-lsp')
  call minpac#add('rizzatti/dash.vim')
  call minpac#add('tpope/vim-endwise')
  call minpac#add('tpope/vim-surround')
  call minpac#add('xolox/vim-misc')
endfunction

command! PackInstall call PackInit() | call minpac#update('', {'do': 'quit'})
command! PackUpdate  call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean   call PackInit() | call minpac#clean()
command! PackStatus  call PackInit() | call minpac#status()
" }}}

" Backup / Swap {{{
set nobackup
set nowritebackup
set noswapfile
" }}}

" TTY Performance {{{
if &compatible
  set nocompatible
endif

set synmaxcol=300
set ttyfast
set lazyredraw
" }}}

" Highlighting {{{
set maxmempattern=20000
set nocursorcolumn
set nocursorline
set updatetime=300
" }}}

" map*leader {{{
let mapleader=" "
let maplocalleader="\\"
" }}}

" Syntax Highlighting {{{
syntax on
let g:jellybeans_use_term_italics = 1
colorscheme jellybeans
filetype plugin indent on

highlight Normal ctermbg=none
highlight NonText ctermbg=none
" }}}

" UI {{{
set number
set numberwidth=1
set clipboard=unnamed
set maxmempattern=10000 " Highlight large files

autocmd VimResized * :wincmd =
" }}}

" Text editing {{{
set autoindent
set splitbelow
set splitright
" }}}

" Whitespace handling {{{
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:»·,trail:·
" }}}

" Formats {{{
autocmd BufNewFile,BufRead Brewfile setf ruby
autocmd BufNewFile,BufRead *.gyp setf json
" }}}

" Keyboard shortcuts {{{
nnoremap <Leader><Tab> <c-^>
nnoremap <leader>j :Buffers<cr>
nnoremap <leader>p :Files<cr>
nnoremap <leader>t :Vista!!<cr>
nnoremap <leader>z :ZoomWinTabToggle<cr>
nnoremap <leader>\ :NERDTreeToggle<cr>
nnoremap <leader>gr :Ag<cr>
nnoremap <leader>got :GoTest<cr>
nnoremap <leader>gotf :GoTestFunc<cr>
nnoremap <leader>gor :GoRun<cr>
nnoremap <leader>god :GoDef<cr>
nnoremap <leader>doc :Dash<cr>
noremap H ^
noremap L $
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap // :noh<cr>

set notimeout
set ttimeout
set ttimeoutlen=10
augroup FastEscape
  autocmd!
  au InsertEnter * set timeoutlen=0
  au InsertLeave * set timeoutlen=1000
augroup END
" }}}

" Quickfix {{{
augroup quickfix
  autocmd!
  autocmd FileType qf wincmd J
  autocmd FileType qf setlocal wrap
augroup END

let g:qf_loclist_window_bottom = 1
" }}}

" Override default behaviour {{{
" Autoread files
set autoread

" Don't deselect when indenting
vnoremap < <gv
vnoremap > >gv
" }}}

" rc reloading {{{
command! Reload source $MYVIMRC
" }}}

" Load files {{{
source ~/.config/nvim/languages/elm.vim
source ~/.config/nvim/languages/golang.vim
source ~/.config/nvim/plugins/fzf.vim
source ~/.config/nvim/plugins/gitgutter.vim
source ~/.config/nvim/plugins/lightline.vim
source ~/.config/nvim/plugins/nerdtree.vim
source ~/.config/nvim/plugins/startify.vim
source ~/.config/nvim/plugins/vim-lsp.vim
source ~/.config/nvim/plugins/vista.vim
" }}}
