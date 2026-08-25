# humor
alias commitmsg='curl -s "http://whatthecommit.com/index.txt"'
alias dadjoke='curl -s "https://icanhazdadjoke.com"'
alias thisforthat='curl -s "http://itsthisforthat.com/api.php?text"'

# serious
alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
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

  if not test -f $path
    echo "evalenv: no such file '$path'" >&2
    return 1
  end

  for line in (cat $path)
    set line (string trim $line)

    test -z "$line"; and continue
    string match -q '#*' -- $line; and continue

    set line (string replace -r '^export\s+' '' -- $line)
    set item (string split -m 1 '=' -- $line)
    test (count $item) -eq 2; or continue

    set key (string trim $item[1])
    set value (string trim -c '\'"' (string trim $item[2]))

    set -gx $key $value
    echo "Exported key $key"
  end
end
