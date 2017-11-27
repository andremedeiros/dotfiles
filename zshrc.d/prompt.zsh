: ${PROMPT_SYMBOL:="❯"}
: ${PROMPT_GIT_AHEAD_SYMBOL:=""}
: ${PROMPT_GIT_BEHIND_SYMBOL:=""}

prompt_helper_git_branch() {
  (git name-rev --name-only --no-undefined --always HEAD || git symbolic-ref -q HEAD) 2> /dev/null
}

prompt_helper_git_ahead() {
  git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' '
}

prompt_helper_git_behind() {
  git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' '
}

prompt_helper_git_modifications() {
  (git diff --quiet || git diff --cached --quiet) 2> /dev/null
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

    if $(prompt_helper_git_modifications); then
      PROMPT="${PROMPT}*"
    fi

    GIT_STATE=""

    git_ahead=$(prompt_helper_git_ahead)
    if [ "$git_ahead" -gt 0 ]; then
      GIT_STATE="${GIT_STATE}${git_ahead}${PROMPT_GIT_AHEAD_SYMBOL}"
    fi

    git_behind=$(prompt_helper_git_behind)
    if [ "$git_behind" -gt 0 ]; then
      GIT_STATE="${GIT_STATE}${git_behind}${PROMPT_GIT_BEHIND_SYMBOL}"
    fi

    if [ ! -n $GIT_STATE ]; then
      PROMPT="${PROMPT} ${GIT_STATE}"
    fi
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
