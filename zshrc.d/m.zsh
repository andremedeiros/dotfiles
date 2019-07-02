function __m {
  local sessname="${1:-$(basename $PWD)}"

  # check tmuxinator
  if [ -e "$HOME/.config/tmuxinator/$sessname.yml" ]; then
    tmuxinator start "$sessname" --suppress-tmux-version-warning
    return
  fi

  # check tmux sessions
  if tmux has-session -t "$sessname" 2>/dev/null; then
    # session exists, lets attach
    tmux attach -t "$sessname"
  else
    # session does not exist, start new one
    tmux new -s "$sessname"
  fi
}

function __mk {
  local sessname="${1:-$(basename $PWD)}"
  sessions=$(tmux ls -F "#S" 2>/dev/null)

  if [ -z "$sessions" ]; then
    echo 'no active sessions'
    return
  fi

  (grep -e "^$sessname$" <<< "$sessions" > /dev/null && tmux kill-session -t "$sessname") || echo 'session not found'
}

alias m='__m'
alias mk='__mk'
