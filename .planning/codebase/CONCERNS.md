# Codebase Concerns

**Analysis Date:** 2026-02-03

## Security Considerations

**Hardcoded credentials and API endpoints:**
- Issue: Shell script `hooks/post-up/12-secrets` contains hardcoded UUIDs to Bitwarden API, exposing structure of credential retrieval even if values are masked
- Files: `hooks/post-up/12-secrets`
- Risk: UUIDs serve as stable identifiers for secret locations; if API is ever compromised, attackers know where to find sensitive material
- Current mitigation: Relies on Bitwarden server being private/self-hosted
- Recommendations: Consider parameterizing UUIDs or using labels/search instead of fixed IDs; store only in environment variables or config files not in git

**Shell injection vulnerability in repo2md:**
- Issue: `repo2md` script at line 20 uses unquoted file path in shell command: `"git grep -I --name-only '' -- #{file}"`
- Files: `bin/repo2md` (line 20)
- Risk: Filenames containing shell metacharacters could lead to command injection
- Current mitigation: Unlikely to occur with git-tracked files, but possible with adversarial filenames
- Recommendations: Use proper escaping via `Shellwords.escape` or avoid shell execution altogether

**Sudoers modification without validation:**
- Issue: `hooks/pre-up/02-setup-sudo` modifies `/etc/sudoers` with banner text that could be hijacked
- Files: `hooks/pre-up/02-setup-sudo`
- Risk: If script is modified to inject malicious sudoers rules, NOPASSWD access is granted to arbitrary commands
- Current mitigation: Script requires full sudoers path which must be in repo version control
- Recommendations: Use `visudo` for safe editing or at minimum validate exact content before appending

**SSH key generation from stored secrets:**
- Issue: `hooks/post-up/12-secrets` writes SSH private keys to disk from Bitwarden, then generates public keys
- Files: `hooks/post-up/12-secrets`
- Risk: Timing window where keys exist on disk unencrypted; no cleanup if script fails partway
- Current mitigation: chmod 600 is set immediately, but directory creation (mkdir) happens after key write
- Recommendations: Create ~/.ssh directory with proper permissions before writing keys; add error trap to ensure cleanup

## Tech Debt

**Deprecated/conflicting runtime configurations:**
- Issue: Project uses multiple runtime managers creating maintenance burden
- Files: `config/mise/config.toml`, `tool-versions`, `Brewfile`
- Impact: Three different ways to specify language versions; mise activation in hooks may conflict with other package managers
- Fix approach: Audit which tools are actually used, consolidate to single source of truth (probably mise)

**Hard-coded shell assumption in llmcat:**
- Issue: Preview script in `bin/llmcat` line 155-161 uses shell syntax within Ruby string that won't work in all shells
- Files: `bin/llmcat` (lines 155-161)
- Impact: Preview fails silently or behaves unexpectedly if bash isn't available; relies on `bat` and `tree` commands
- Fix approach: Refactor preview logic into separate shell script or Ruby code that doesn't assume bash

**Ruby script fragility with external dependencies:**
- Issue: Multiple Ruby bin scripts have undeclared external dependencies (repo2md needs git, herald-crosswords needs gs/ghostscript)
- Files: `bin/repo2md`, `bin/herald-crosswords`
- Impact: Scripts fail with cryptic errors if dependencies missing; no version checking
- Fix approach: Add explicit dependency checks with helpful error messages at script start

## Performance Bottlenecks

**repo2md reads large files twice:**
- Problem: Line 37-38 in `repo2md` reads file content once, then checks if it ends with newline by reading again
- Files: `bin/repo2md` (lines 37-38)
- Cause: `File.read(file)` called once for content, again for newline check
- Improvement path: Read once, store in variable, check with `.end_with?` on stored string

**herald-crosswords hardcoded 4-thread pool:**
- Problem: `thread_pool` function at line 17 uses fixed pool_size of 4, ignoring CPU count
- Files: `bin/herald-crosswords` (line 81)
- Cause: No dynamic sizing based on machine resources
- Improvement path: Default to CPU count or allow via environment variable `CROSSWORD_THREADS`

**llmcat subprocess creation overhead:**
- Problem: Complex fzf setup with multiple subshells and subprocesses for preview rendering
- Files: `bin/llmcat` (lines 146-184)
- Cause: fzf preview script evaluated in subshell on every keystroke; bat/tree called for each preview
- Improvement path: Cache preview output or use native fzf features (--preview-window-size)

## Fragile Areas

**herald-crosswords date parsing:**
- Files: `bin/herald-crosswords` (lines 52-66)
- Why fragile: Line 53 splits duration string by `split("")` which splits into characters, not amount/unit. Logic depends on manual string reassembly at line 54-55. If duration format changes slightly, silently fails.
- Safe modification: Use `scan` or regex instead: `amount, unit = options[:duration].scan(/(\d+)(\D)/).flatten`
- Test coverage: No tests; manual usage only

**Bitwarden API dependency without fallback:**
- Files: `hooks/post-up/12-secrets` (entire script)
- Why fragile: Script assumes Bitwarden server is running and accessible. If URL or UUIDs change, secrets cannot be provisioned. No validation that imported keys actually work.
- Safe modification: Add pre-flight checks: validate Bitwarden server reachability, validate imported key format with ssh-keygen before marking success
- Test coverage: No tests; runs during full system bootstrap

**mktemp usage with predictable template:**
- Files: `hooks/post-up/04-terminfo`, `hooks/post-up/05-gen-codesign-cert`
- Why fragile: Both use `/tmp/XXXXXX` pattern which has 6 random hex digits. On systems with many processes, collision risk increases. Templates should use mktemp's secure default.
- Safe modification: Use `mktemp` without specifying template (defaults to `/tmp/tmp.XXXXXX` with more entropy) or use `-t` flag to respect TMPDIR
- Test coverage: Not tested; failure only shows up in multi-user environments

**Hardcoded git remote 'origin' in git-rewrite-branch:**
- Files: `bin/git-rewrite-branch` (line 15)
- Why fragile: Assumes remote is named 'origin'; modern git allows arbitrary remote names. Force-push without confirmation.
- Safe modification: Auto-detect current upstream or prompt user; add `--force` flag requirement to match git's safety
- Test coverage: No tests; used manually

**Shell-dependent llmcat fzf bindings:**
- Files: `bin/llmcat` (lines 175-177)
- Why fragile: fzf reload commands use inline shell syntax that may not work in all environments. Sed command at line 172 assumes GNU sed.
- Safe modification: Test with macOS/BSD sed and Linux sed variants; use sed -E instead of -r
- Test coverage: Not tested; interactive-only tool

## Known Bugs

**herald-crosswords incomplete execution:**
- Symptoms: Script completes fzf selection but hangs or terminates abnormally when trying to exec ghostscript
- Files: `bin/herald-crosswords` (lines 113-118)
- Trigger: After successfully downloading PDFs, when trying to execute `gs` command to merge them
- Issue: Lines 113-118 call `exec()` which replaces the script process, then `sleep` for huge number. If exec fails, sleep continues indefinitely. Exception handler catches and prints error, but script continues in background.
- Workaround: Kill process manually, check if ghostscript is installed

**repo2md binary file detection may be slow:**
- Symptoms: Script hangs or takes very long time on large repositories
- Files: `bin/repo2md` (lines 16-22)
- Trigger: Called on repos with thousands of files; each file checked with separate `git grep` call
- Issue: O(n) git grep operations means linear performance degradation with repo size
- Workaround: Use `git check-ignore` or `file` command instead; batch operations

**llmcat gitignore parsing fails on complex patterns:**
- Symptoms: Some files still appear in selection despite .gitignore
- Files: `bin/llmcat` (lines 125-134)
- Trigger: Gitignore with negation patterns (!) or complex path matching
- Issue: Simplistic sed-based conversion doesn't handle all gitignore syntax
- Workaround: Use `git check-ignore` command instead of parsing

## Missing Critical Features

**No automated testing:**
- Problem: No test framework, test files, or CI pipeline for shell/ruby scripts
- Blocks: Cannot safely refactor scripts; contributors cannot verify changes work
- Impact: Bugs like herald-crosswords hanging bug would have been caught with basic integration tests

**No error recovery in bootstrap hooks:**
- Problem: Many hooks use `set -e` but don't clean up partial state on failure
- Blocks: Failed bootstrap leaves system in inconsistent state (partial secrets, incomplete configurations)
- Impact: Manual intervention required to recover; users may not know which steps failed

**No version pinning for dependencies:**
- Problem: Brewfile, mise config, and language managers pull latest versions without constraints
- Blocks: Cannot guarantee reproducible bootstraps across time or machines
- Impact: System configuration drifts; what works today may break tomorrow

## Test Coverage Gaps

**Shell scripts lack validation:**
- What's not tested: All bash/sh scripts in hooks/ and bin/ directories
- Files: `hooks/pre-up/*`, `hooks/post-up/*`, `bin/llmcat`, `bin/git-rewrite-branch`, and others
- Risk: Syntax errors, logic bugs, and environment assumptions go unnoticed; shell behavior varies across platforms (macOS vs Linux)
- Priority: High - bootstrap scripts must be reliable

**Ruby utility scripts lack coverage:**
- What's not tested: repo2md, herald-crosswords, titlecase, alacify, and other bin/ scripts
- Files: `bin/repo2md`, `bin/herald-crosswords`, `bin/titlecase`, `bin/alacify`
- Risk: Changes to Ruby syntax or gem versions break functionality silently; edge cases in parsing logic undiscovered
- Priority: High - widely used utilities

**Integration testing missing:**
- What's not tested: Full bootstrap flow; interaction between hooks and configuration
- Files: All hooks/ and config/ files
- Risk: Hook ordering bugs, conflicting configurations, and environment variable pollution not caught
- Priority: Medium - critical path but used infrequently

**Cross-platform compatibility untested:**
- What's not tested: Scripts behavior on different macOS versions, different hardware (Intel vs Apple Silicon)
- Files: All shell and ruby scripts
- Risk: macOS Big Sur vs Sonoma differences, sed behavior variations, mktemp path differences
- Priority: Medium - affects deployment reliability

---

*Concerns audit: 2026-02-03*
