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
