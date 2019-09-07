" Vista {{{
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

let g:vista#renderer#enable_icon = 0
let g:vista_close_on_jump = 1
let g:vista_default_executive = 'vim_lsp'
" }}}
