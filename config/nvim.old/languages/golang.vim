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
