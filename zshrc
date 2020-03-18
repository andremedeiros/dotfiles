# requirements
if [ ! -f ~/.brew.zsh ]; then
  brew shellenv > ~/.brew.zsh
fi

source ~/.brew.zsh

# magic loading
for plugin ($HOME/.zshrc.d/plugins/*.plugin.zsh) source $plugin
for include ($HOME/.zshrc.d/*.zsh) source $include

# load home environment
if [ -f ~/.env ]; then
  set -o allexport
  source ~/.env
  set +o allexport
fi

# load modules
autoload -Uz compinit; compinit
autoload -Uz bashcompinit; bashcompinit

# asdf
source $HOMEBREW_PREFIX/opt/asdf/asdf.sh
source $HOMEBREW_PREFIX/opt/asdf/etc/bash_completion.d/asdf.bash

# dir hopping
source $HOMEBREW_PREFIX/etc/profile.d/z.sh

# syntax highlighting
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# completions
fpath=($HOMEBREW_PREFIX/share/zsh-completions $fpath)

# colorize all the things
source $HOMEBREW_PREFIX/etc/grc.bashrc

# make history useful
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
