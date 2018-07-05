# magic loading
for plugin ($HOME/.zshrc.d/plugins/*.plugin.zsh) source $plugin
for include ($HOME/.zshrc.d/*.zsh) source $include

# load modules
autoload -Uz compinit; compinit

# chruby
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

# nvm
source /usr/local/opt/nvm/nvm.sh

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
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
