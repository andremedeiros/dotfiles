# functions to alias below
function __servedir {
  ruby -run -ehttpd ${1-${PWD}} -p8000
}

# humor
alias commitmsg='curl -s "https://whatthecommit.com/index.txt"'
alias dadjoke='curl -s "https://icanhazdadjoke.com"'
alias thisforthat='curl -s "http://itsthisforthat.com/api.php?text"'

# serious
alias code="code --user-data-dir=$HOME/.config/code"
alias git="hub"
alias hl="highlight -O ansi -n"
alias ia="open $1 -a /Applications/iA\ Writer.app"
alias ls="gls --color=auto -F"
alias npm-unfuck="sed -i '' 's/http:/https:/g' package-lock.json"
alias servedir='__servedir'

# projects
alias dbundle="ruby -I $HOME/src/github.com/bundler/bundler $HOME/src/github.com/bundler/bundler/exe/bundle"
alias dembark="$HOME/src/github.com/embark-framework/embark/packages/embark/bin/embark"

# misc
alias weather="curl wttr.in"
