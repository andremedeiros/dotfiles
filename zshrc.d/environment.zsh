# go
export GOPATH=$HOME

# nodejs
export NVM_DIR=$HOME/.nvm
export NODE_OPTIONS="--stack-trace-limit=10000 --trace-warnings"

# editor
export VISUAL=nvim
export EDITOR=nvim

# add custom bin directories to path
export PATH=/usr/local/opt/python/libexec/bin:$PATH
export PATH=$PATH:~/.bin
export PATH=$PATH:$GOPATH/bin

# shell history
export HISTFILE=~/.histfile
export HISTSIZE=1000
export SAVEHIST=1000

# ui
export TERM=xterm-256color
