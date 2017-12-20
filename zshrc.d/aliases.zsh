# humor
alias dadjoke='curl -s "https://icanhazdadjoke.com"'
alias thisforthat='curl -s "http://itsthisforthat.com/api.php?text"'

# serious
alias git="hub"
alias ia="open $1 -a /Applications/iA\ Writer.app"
alias ls="gls --color=auto -F"
alias servedir="ruby -run -ehttpd . -p8000"

# misc
alias weather="curl wttr.in"

# dir hopping
if [[ -f /opt/dev/dev.sh ]]; then
  alias z="dev cd"
fi
