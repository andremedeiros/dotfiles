# go
export GOPATH=$HOME/.go

# nodejs
export NODE_OPTIONS="--stack-trace-limit=10000 --trace-warnings"

# editor
export VISUAL=nvim
export EDITOR=nvim

# add custom bin directories to path
export PATH=/usr/local/sbin:$PATH
export PATH=$PATH:~/.bin
export PATH=$PATH:$GOPATH/bin

# shell history
export HISTFILE=~/.histfile
export HISTSIZE=1000
export SAVEHIST=1000

# ui
export TERM=xterm-256color

# nnn
export NNN_TMPFILE="/tmp/nnn"
