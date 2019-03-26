function __vagrant {
  VAGRANT_CWD=$HOME VAGRANT_VAGRANTFILE=$HOME/.Vagrantfile vagrant "$1"
}

alias nixup="__vagrant up"
alias nixssh="__vagrant ssh"
alias nixdown="__vagrant halt"
alias nixboom="__vagrant destroy"
