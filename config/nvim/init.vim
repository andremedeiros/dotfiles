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
let g:qf_loclist_window_bottom = 1
" }}}

" Lightline {{{
let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'component_expand': {
      \ 'linter_warnings': 'lightline#ale#warnings',
      \ 'linter_errors': 'lightline#ale#errors',
      \ 'linter_ok': 'lightline#ale#ok',
    \ },
    \ 'component_function': {
      \ 'gitbranch': 'fugitive#head',
    \ },
    \ 'component': {
      \ 'gitgutter_added': '%#HunksElementColor0#%{LightlineGitAddedCount()}',
      \ 'gitgutter_modified': '%#HunksElementColor1#%{LightlineGitModifiedCount()}',
      \ 'gitgutter_removed': '%#HunksElementColor2#%{LightlineGitRemovedCount()}',
    \},
    \ 'component_type': {
      \ 'linter_warnings': 'warning',
      \ 'linter_errors': 'error',
      \ 'gitgutter_added': 'raw',
      \ 'gitgutter_modified': 'raw',
      \ 'gitgutter_removed': 'raw',
    \ },
    \ 'active': {
      \ 'right': [
        \ [ 'lineinfo' ],
        \ [ 'linter_errors', 'linter_warnings', 'linter_ok' ],
        \ [ 'gitbranch', 'gitgutter_added', 'gitgutter_modified', 'gitgutter_removed' ]
      \ ]
    \ },
    \ 'subseparator': {
      \ 'right': ''
    \ }
  \ }

function! LightlineFormatGitCount(symbol, idx, color)
  let hunks = GitGutterGetHunkSummary()
  let string = ''

  if hunks[a:idx] > 0
    let string .= printf('%s%s ', a:symbol, hunks[a:idx])
  endif

  exe printf('hi HunksElementColor%d ctermbg=236 guibg=#30302c ctermfg=%d guifg=%s term=bold cterm=bold', a:idx, a:color[1], a:color[0])
  return string
endfunction

function! LightlineGitAddedCount()
  return LightlineFormatGitCount('+', 0, ['#8bc34a', 148])
endfunction

function! LightlineGitModifiedCount()
  return LightlineFormatGitCount('~', 1, ['#ff9800', 208])
endfunction

function! LightlineGitRemovedCount()
  return LightlineFormatGitCount('-', 2, ['#f44336', 196])
endfunction
" }}}

" FZF {{{
set rtp+=/usr/local/opt/fzf

let $FZF_DEFAULT_COMMAND = 'ag -g ""'
" }}}

" GitGutter {{{
let g:gitgutter_map_keys = 0
" }}}

" Startify {{{
let g:startify_change_to_dir = 0
" }}}

" NERDTree {{{
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}

" Keyboard shortcuts {{{
nnoremap <leader>j :Buffers<cr>
nnoremap <leader>p :Files<cr>
nnoremap <leader>t :TagbarToggle<cr>
nnoremap <leader>z :ZoomWinTabToggle<cr>
nnoremap <leader>\ :NERDTreeToggle<cr>
nnoremap <leader>got :GoTest<cr>
nnoremap <leader>gotf :GoTestFunc<cr>
nnoremap <leader>gor :GoRun<cr>
nnoremap <leader>god :GoDef<cr>
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

" Use quickfix
let g:ale_set_quickfix = 1
let g:ale_set_loclist = 0

" Increase lint delay
let g:ale_lint_delay = 2000
" }}}

" Override default behaviour {{{

" Don't deselect when indenting
vnoremap < <gv
vnoremap > >gv
" }}}
