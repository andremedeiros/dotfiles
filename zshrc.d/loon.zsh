
__loon_path="/Users/andremedeiros/src/github.com/andremedeiros/loon/loon"

_l() {
	local tmp ret finalizer

	tmp="$(mktemp -u)"
	exec 9>"${tmp}"
	exec 8<"${tmp}"
	rm ${tmp}

	"${__loon_path}" "$@"
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
		