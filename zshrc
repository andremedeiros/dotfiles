# magic loading
for include ($HOME/.zshrc.d/*.zsh) source $include

# load modules
autoload -Uz compinit; compinit

# load dev if present, otherwise load chruby
if [[ -f /opt/dev/dev.sh ]]; then
  source /opt/dev/dev.sh
else
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  source /usr/local/opt/chruby/share/chruby/auto.sh
fi

# dir hopping
source /usr/local/etc/profile.d/z.sh

# syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# completions
fpath=(/usr/local/share/zsh-completions $fpath)

# colorize all the things
source /usr/local/etc/grc.bashrc

# make history useful
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_ignore_space
