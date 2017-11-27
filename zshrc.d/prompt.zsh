: ${PROMPT_SYMBOL:="❯"}

prompt_helper_path() {
  print -Pn '%~'
}

prompt_precmd() {
  # Path
  PROMPT="%F{"12"}`prompt_helper_path`%f"

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
