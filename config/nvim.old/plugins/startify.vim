" Startify {{{
let g:startify_change_to_dir = 0
let g:startify_custom_header =
  \ map(split(system('darkwing | cowthink -f vader'), '\n'), '"   ". v:val') + ['','']
" }}}
