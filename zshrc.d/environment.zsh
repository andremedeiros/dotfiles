# go
export GOPATH=$HOME/.go

# nodejs
export NODE_OPTIONS="--stack-trace-limit=10000 --trace-warnings"

# editor
export VISUAL=nvim
export EDITOR=nvim

# add custom bin directories to path
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

# ruby
export RUBYOPT="-W0"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl@1.1"

# docker
export DOCKER_HOST="tcp://groot.local:2375"
