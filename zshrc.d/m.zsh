function __m {
  # check whether we're passing an argument
  if [ $# -eq 0 ]; then
    echo 'project name required'
    return
  fi

  # check tmuxinator
  if [ -e "$HOME/.config/tmuxinator/$1.yml" ]; then
    tmuxinator start $1
    return
  fi

  # check tmux sessions
  tmux list-sessions | grep "$1:" > /dev/null
  if [ $? -eq 0 ]; then
    # session exists, lets attach
    tmux attach -t $1
  else
    # session does not exist, start new one
    tmux new -s $1
  fi
}

alias m='__m'
alias mk='tmux kill-session -t'

