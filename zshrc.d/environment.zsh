# go
export GOPATH=$HOME/.go

# nodejs
export NODE_OPTIONS="--stack-trace-limit=10000 --trace-warnings"

# editor
export VISUAL=nvim
export EDITOR=nvim

# add custom bin directories to path
export PATH=~/.asdf/shims:$PATH
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

# ruby temporary fix
export DISABLE_SPRING=true

# direnv
_direnv_hook() {
  trap -- '' SIGINT;
  eval "$("/opt/homebrew/bin/direnv" export zsh)";
  trap - SIGINT;
}
typeset -ag precmd_functions;
if [[ -z "${precmd_functions[(r)_direnv_hook]+1}" ]]; then
  precmd_functions=( _direnv_hook ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z "${chpwd_functions[(r)_direnv_hook]+1}" ]]; then
  chpwd_functions=( _direnv_hook ${chpwd_functions[@]} )
fi
