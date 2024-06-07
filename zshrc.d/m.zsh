function __m {
  local sessname="${1:-$(basename $PWD)}"

  # check zellij sessions
  if zellij list-sessions --short | grep "$sessname" 2>/dev/null; then
    # session exists, lets attach
    zellij attach "$sessname"
  else
    # session does not exist, start new one
    zellij -s "$sessname"
  fi
}

alias m='__m'
