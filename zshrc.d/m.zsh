function __m {
  # check whether we're passing an argument
  if [ $# -eq 0 ]; then
    echo 'session name required'
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

function __mk {
  sessions=$(tmux ls -F "#S" 2>/dev/null)

  if [ $# -eq 0 ]; then
    if [ -z $sessions ]; then
      echo 'no active sessions'
    else
      echo $sessions
    fi

    return
  fi

  (grep -e "^$1$" <<< "$sessions" && tmux kill-session -t $1) || echo 'session not found'
}

alias m='__m'
alias mk='__mk'

