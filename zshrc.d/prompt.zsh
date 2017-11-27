: ${PROMPT_SYMBOL:="❯"}

prompt_helper_git_branch() {
  (git name-rev --name-only --no-undefined --always HEAD || git symbolic-ref -q HEAD) 2> /dev/null
}

prompt_helper_path() {
  print -Pn '%~'
}

prompt_precmd() {
  # Path
  PROMPT="%F{"12"}`prompt_helper_path`%f"

  # Git
  git_branch=$(prompt_helper_git_branch)
  if [ -n $git_branch ]; then
    PROMPT="${PROMPT} %F{"11"}%B${git_branch}%b%f"
  fi

  # Prompt separator
  PROMPT="${PROMPT} %F{"1"}%B${PROMPT_SYMBOL}%b%f "
}

prompt_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  add-zsh-hook precmd prompt_precmd

  return 0
}

prompt_setup "$@"
