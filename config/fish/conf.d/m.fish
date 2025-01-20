function __m --argument sessname
  set -q sessname[1]; or set sessname (basename $PWD)
  if zellij list-sessions --short | grep "$sessname" 2>/dev/null
    zellij attach "$sessname"
  else
    zellij -s "$sessname"
  end
end

alias m='__m'
