" Thanks @fatih for a lot of these.

" Preamble {{{
packadd minpac

call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})

" language/syntax
call minpac#add('ElmCast/elm-vim')
call minpac#add('andremedeiros/ragel.vim')
call minpac#add('fatih/vim-go', {'do': ':GoUpdateBinaries'})
call minpac#add('isRuslan/vim-es6')
call minpac#add('leafgarland/typescript-vim')
call minpac#add('tmux-plugins/vim-tmux')
call minpac#add('tomlion/vim-solidity')
call minpac#add('vim-ruby/vim-ruby')

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

command! PackUpdate call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call minpac#clean()
command! PackStatus call minpac#status()
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

" TTY looks {{{
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
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

" Go {{{
augroup golang
  au!
  au BufNewFile,BufRead *.go set nolist
  au Filetype go set makeprg=go\ build\ ./...
augroup END

set rtp+=~/src/github.com/golang/lint/misc/vim

let g:go_def_mode = 'gopls'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
" }}}

" Quickfix {{{
let g:qf_loclist_window_bottom = 1
" }}}

" Lightline {{{
let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'component_function': {
      \ 'gitbranch': 'fugitive#head',
      \ 'method': 'NearestMethodOrFunction',
    \ },
    \ 'component': {
      \ 'gitgutter_added': '%#HunksElementColor0#%{LightlineGitAddedCount()}',
      \ 'gitgutter_modified': '%#HunksElementColor1#%{LightlineGitModifiedCount()}',
      \ 'gitgutter_removed': '%#HunksElementColor2#%{LightlineGitRemovedCount()}',
    \},
    \ 'component_type': {
      \ 'gitgutter_added': 'raw',
      \ 'gitgutter_modified': 'raw',
      \ 'gitgutter_removed': 'raw',
    \ },
    \ 'active': {
      \ 'left': [
        \ ['mode', 'paste'],
        \ ['readonly', 'filename', 'modified', 'method']
      \ ],
      \ 'right': [
        \ [ 'lineinfo' ],
        \ [ 'gitbranch' ],
        \ [ 'gitgutter_added', 'gitgutter_modified', 'gitgutter_removed' ]
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
let g:startify_custom_header =
  \ map(split(system('darkwing | cowthink -f vader'), '\n'), '"   ". v:val') + ['','']
" }}}

" NERDTree {{{
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}

" Keyboard shortcuts {{{
nnoremap <leader>j :Buffers<cr>
nnoremap <leader>p :Files<cr>
nnoremap <leader>t :Vista!!<cr>
nnoremap <leader>z :ZoomWinTabToggle<cr>
nnoremap <leader>\ :NERDTreeToggle<cr>
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
" }}}

" Vista {{{
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

let g:vista#renderer#enable_icon = 0
let g:vista_close_on_jump = 1
let g:vista_default_executive = 'vim_lsp'
" }}}

" LSP {{{
" I kinda wish I could use gopls but for some reason its output ins't
" making LSP happy.
au User lsp_setup call lsp#register_server({
  \ 'name': 'go-langserver',
  \ 'cmd': {server_info->['go-langserver', '-gocodecompletion']},
  \ 'whitelist': ['go'],
  \ })

au User lsp_setup call lsp#register_server({
  \ 'name': 'javascript support using typescript-language-server',
  \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
  \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
  \ 'whitelist': ['javascript', 'javascript.jsx', 'typescript', 'typescript.tsx']
  \ })

au User lsp_setup call lsp#register_server({
  \ 'name': 'ccls',
  \ 'cmd': {server_info->['ccls']},
  \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
  \ 'initialization_options': {},
  \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
  \ })

au User lsp_setup call lsp#register_server({
  \ 'name': 'docker-langserver',
  \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
  \ 'whitelist': ['dockerfile'],
  \ })

highlight link LspErrorText Error
highlight link LspHintText Comment
highlight link LspWarningText Warning

let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1

let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'}
let g:lsp_signs_hint = {'text': 'ℹ︎'}
" }}}

" Override default behaviour {{{
" Autoread files
set autoread

" Don't deselect when indenting
vnoremap < <gv
vnoremap > >gv
" }}}
