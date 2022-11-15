" Lightline {{{
let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'component_function': {
      \ 'gitbranch': 'FugitiveHead',
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
