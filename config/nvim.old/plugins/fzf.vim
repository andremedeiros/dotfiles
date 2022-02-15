" FZF {{{
let g:fzf_files_options = '--ansi --preview "highlight -O ansi --force {}" --preview-window right:100'

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:60%'),
  \                 <bang>0)

" }}}

