source ~/.zshrc.d/environment.zsh
source ~/.zshrc.d/nixbox.zsh

# load dev if present, otherwise load chruby
if [[ -f /opt/dev/dev.sh ]]; then
  source /opt/dev/dev.sh
else
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  source /usr/local/opt/chruby/share/chruby/auto.sh
fi

