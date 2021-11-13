# requirements
if [ ! -f ~/.brew.zsh ]; then
  /opt/homebrew/bin/brew shellenv > ~/.brew.zsh
fi

source ~/.brew.zsh

# load modules
autoload -Uz compinit; compinit
autoload -Uz bashcompinit; bashcompinit

# magic loading
for plugin ($HOME/.zshrc.d/plugins/*.plugin.zsh) source $plugin
for include ($HOME/.zshrc.d/*.zsh) source $include

# load home environment
if [ -f ~/.env ]; then
  __evalenv ~/.env
fi

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
source $HOMEBREW_PREFIX/etc/grc.zsh

# make history useful
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space

helpers=()
helpers=("${helpers[@]}" ".netlify/helper/path.zsh.inc")
helpers=("${helpers[@]}" ".nix-profile/etc/profile.d/nix.sh")

for helper in "${helpers[@]}"; do
  [ -f $HOME/$helper ] && source $HOME/$helper
done
