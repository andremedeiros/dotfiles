# humor
alias commitmsg='curl -s "http://whatthecommit.com/index.txt"'
alias dadjoke='curl -s "https://icanhazdadjoke.com"'
alias thisforthat='curl -s "http://itsthisforthat.com/api.php?text"'

# serious
alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias git="hub"
alias hl="highlight -O ansi -n"
alias ia="__ia"
alias ifup='curl -s "https://api.ipify.org"'
alias servedir='__servedir'
alias ee='__evalenv'
alias weather="curl wttr.in"

function __ia --argument path
  open $path -a "/Applications/iA Writer.app"
end

function __servedir --argument port
  set -q port[1]; or set port 8000
  python -m http.server "$port"
end

function __evalenv --argument path
  set -q path[1]; or set path ".env"
  for line in (cat $path | grep -v '^#' | grep -v '^\s*$')
    set item (string split -m 1 '=' $line)
    set -gx $item[1] $item[2]
    echo "Exported key $item[1]"
  end
end
