function __servedir {
  local served_dir=$PWD
  if [[ ! -z "$@" ]]; then
    served_dir=$@
  fi

  ruby -run -ehttpd $served_dir -p8000
}

# humor
alias dadjoke='curl -s "https://icanhazdadjoke.com"'
alias thisforthat='curl -s "http://itsthisforthat.com/api.php?text"'

# serious
alias git="hub"
alias hl="highlight -O ansi -n"
alias ia="open $1 -a /Applications/iA\ Writer.app"
alias ls="gls --color=auto -F"
alias servedir='__servedir'

# misc
alias weather="curl wttr.in"
