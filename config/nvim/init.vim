" Preamble {{{
execute pathogen#infect()
" }}}

" Backup / Swap {{{
set nobackup
set nowritebackup
set noswapfile
" }}}

" TTY Performance {{{
set nocompatible
set synmaxcol=300
set ttyfast
set lazyredraw
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
" }}}

" UI {{{
set number
set numberwidth=1
set clipboard=unnamed

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

autocmd BufWritePre * %s/\s\+$//e
" }}}

" Makefile {{{
augroup makefile
  au!
  au FileType make set noexpandtab
augroup END
" }}}

" Homebrew {{{
autocmd BufNewFile,BufRead Brewfile setf ruby
" }}}

" Go {{{
augroup golang
  au!
  au BufNewFile,BufRead *.go set nolist
  au Filetype go set makeprg=go\ build\ ./...

  autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow
augroup END

set rtp+=~/src/github.com/golang/lint/misc/vim

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
" }}}

" Quickfix {{{
let g:qf_loclist_window_bottom=0
" }}}

" Lightline {{{
let g:lightline = {
  \ 'colorscheme': 'jellybeans'
  \ }

let g:lightline.component_expand = {
  \  'linter_warnings': 'lightline#ale#warnings',
  \  'linter_errors': 'lightline#ale#errors',
  \  'linter_ok': 'lightline#ale#ok',
  \ }

let g:lightline.component_type = {
  \     'linter_warnings': 'warning',
  \     'linter_errors': 'error',
  \ }

let g:lightline.active = { 'right': [
  \ [ 'lineinfo' ],
  \ [ 'linter_errors', 'linter_warnings', 'linter_ok' ],
  \ ] }
" }}}

" FZF {{{
set rtp+=/usr/local/opt/fzf

let $FZF_DEFAULT_COMMAND = 'ag -g ""'
" }}}

" Netrw {{{
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" }}}

" Keyboard shortcuts {{{
nnoremap <leader>j :Buffers<cr>
nnoremap <leader>p :Files<cr>
nnoremap <leader>t :TagbarToggle<cr>
noremap H ^
noremap L $
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap // :noh<cr>
" }}}

" ALE {{{
" Disable highlighting
let g:ale_set_highlights = 0
" }}}

" Override default behaviour {{{

" Don't deselect when indenting
vnoremap < <gv
vnoremap > >gv
" }}}
