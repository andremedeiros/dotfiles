# GitHub MCP server (github@claude-plugins-official omp plugin) reads
# GITHUB_PERSONAL_ACCESS_TOKEN for its Authorization header. Feed it the
# gh token — already SSO-authorized — instead of a static PAT that would
# go stale. Only set when gh is authed; ~50ms once per shell.
if not set -q GITHUB_PERSONAL_ACCESS_TOKEN; and command -q gh; and gh auth status >/dev/null 2>&1
    set -gx GITHUB_PERSONAL_ACCESS_TOKEN (gh auth token)
end
