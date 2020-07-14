#compdef _l

_loon_autocomplete() {
	local -a opts
	local cur
	cur=${words[-1]}
	if [[ "$cur" == "-"* ]]; then
		opts=("${(@f)$(_CLI_ZSH_AUTOCOMPLETE_HACK=1 ${words[@]:0:#words[@]-1} ${cur} --generate-bash-completion)}")
	else
		opts=("${(@f)$(_CLI_ZSH_AUTOCOMPLETE_HACK=1 ${words[@]:0:#words[@]-1} --generate-bash-completion)}")
	fi

	if [[ "${opts[1]}" != "" ]]; then
		_describe 'values' opts
	else
		_files
	fi

	return
}

compdef _loon_autocomplete _l

_l() {
	local finalizer loon ret tmp
	loon="/Users/andremedeiros/src/github.com/andremedeiros/loon/loon"

	tmp="$(mktemp -u)"
	exec 9>"${tmp}"
	exec 8<"${tmp}"
	rm ${tmp}

	"${loon}" "$@"
	ret=$?

	while read -r finalizer; do
		case "${finalizer}" in
			chdir:*) cd "${finalizer//chdir:/}" ;;
			*) ;;
		esac
	done <&8

	exec 8<&-
	exec 9<&-

	return ${ret}
}

alias loon="_l"

