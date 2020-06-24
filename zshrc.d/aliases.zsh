function __servedir {
  ruby -run -ehttpd "${1-${PWD}}" -p8000
}

function __ia {
  open "$1" -a /Applications/iA\ Writer.app
}

# humor
alias commitmsg='curl -s "http://whatthecommit.com/index.txt"'
alias dadjoke='curl -s "https://icanhazdadjoke.com"'
alias thisforthat='curl -s "http://itsthisforthat.com/api.php?text"'

# loon
alias l="_l"
alias le="l exec"
alias lu="l up"
alias ll="l down"

# serious
alias code="code --user-data-dir=\$HOME/.config/code"
alias git="hub"
alias hl="highlight -O ansi -n"
alias ia="__ia"
alias ifup='curl -s "https://api.ipify.org"'
alias ls="gls --color=auto -F"
alias mux="tmuxinator"
alias npm-unfuck="sed -i '' 's/http:/https:/g' package-lock.json"
alias sc='shellcheck -s bash'
alias servedir='__servedir'

# projects
alias dbundle="ruby -I \$HOME/src/github.com/bundler/bundler \$HOME/src/github.com/bundler/bundler/exe/bundle"
alias dembark="\$HOME/src/github.com/embark-framework/embark/packages/embark/bin/embark"

# misc
alias fucking="sudo"
alias moon="curl wttr.in/moon"
alias ts=" date '+%Y%m%d%H%M%S'"
alias weather="curl wttr.in"

# ruby
alias be="bundle exec"
