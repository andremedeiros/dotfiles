# go
set -gx GOPATH $HOME/.go

# nodejs
set -gx NODE_OPTIONS "--stack-trace-limit=10000 --trace-warnings"

# editor
set -gx VISUAL nvim
set -gx EDITOR nvim

# add custom bin directories to path
fish_add_path -gP $HOME/.bin
fish_add_path -gP $GOPATH/bin

# ui
set -gx TERM xterm-256color

# nnn
set -gx NNN_TMPFILE "/tmp/nnn"

# direnv
direnv hook fish | source
