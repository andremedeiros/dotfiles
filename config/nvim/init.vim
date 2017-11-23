" Preamble {{{
execute pathogen#infect()
" }}}

" map*leader {{{
let mapleader=" "
let maplocalleader="\\"
" }}}

" Syntax Highlighting {{{
syntax on
colorscheme jellybeans
filetype plugin indent on
" }}}

" NeoVim {{{
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1

  " Neovim takes a different approach to initializing the GUI. As It seems some
  " Syntax and FileType autocmds don't get run all for the first file specified
  " on the command line.  hack sidesteps that and makes sure we get a chance to
  " get started. See https://github.com/neovim/neovim/issues/2953
  augroup nvim
    au!
    au VimEnter * doautoa Syntax,FileType
  augroup END
endif
" }}}

" Lightline {{{
let g:lightline = {
  \ 'colorscheme': 'jellybeans'
  \ }
" }}}

" FZF {{{
set rtp+=/usr/local/opt/fzf

nnoremap <leader>j :Buffers<cr>
nnoremap <leader>p :Files<cr>
" }}}