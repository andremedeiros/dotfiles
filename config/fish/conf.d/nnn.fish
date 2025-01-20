function __nnn
  nnn $argv

  if test -f $NNN_TMPFILE
    source $NNN_TMPFILE
    rm $NNN_TMPFILE
  end
end

alias n='__nnn'
