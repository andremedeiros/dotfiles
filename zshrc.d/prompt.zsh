: ${PROMPT_SYMBOL:=">"}
: ${PROMPT_UNSTAGED_SYMBOL:="*"}
: ${PROMPT_STAGED_SYMBOL:="!"}

prompt_helper_path() {
  print -Pn '%~'
}

prompt_precmd() {
  vcs_info

  PROMPT="%F{"12"}`prompt_helper_path`%f${vcs_info_msg_0_} %F{"1"}%B${PROMPT_SYMBOL}%b%f "
}

prompt_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' formats "%F{11} %b%f%F{1}%u%c%f"
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' unstagedstr $PROMPT_UNSTAGED_SYMBOL
  zstyle ':vcs_info:*' stagedstr $PROMPT_STAGED_SYMBOL

  setopt prompt_subst

  add-zsh-hook precmd prompt_precmd
}

prompt_setup "$@"
