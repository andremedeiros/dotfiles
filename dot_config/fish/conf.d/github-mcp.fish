# GitHub MCP server (github@claude-plugins-official omp plugin) reads
# GITHUB_PERSONAL_ACCESS_TOKEN for its Authorization header. Feed it the
# gh token — already SSO-authorized — instead of a static PAT that would
# go stale. `gh auth token` reads local credentials only; `gh auth status`
# makes a network round trip (~330ms, unbounded when offline), so avoid it.
if not set -q GITHUB_PERSONAL_ACCESS_TOKEN; and command -q gh
    set -l token (gh auth token 2>/dev/null)
    test -n "$token"; and set -gx GITHUB_PERSONAL_ACCESS_TOKEN $token
end
