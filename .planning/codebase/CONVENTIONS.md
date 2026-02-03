# Coding Conventions

**Analysis Date:** 2026-02-03

## Naming Patterns

**Files:**
- Shell scripts: `lowercase-with-hyphens` (e.g., `git-rewrite-branch`, `nix-update`)
- Ruby scripts: `lowercase-with-hyphens` (e.g., `repo2md`, `herald-crosswords`)
- Configuration files: `lowercase.format` (e.g., `starship.toml`, `zellij.kdl`)
- Vim/Neovim config: `init.vim`, plugin files follow `plugin-name.vim` pattern

**Functions (Ruby):**
- snake_case for method names
- Class methods and instance methods both use snake_case
- Example from `titlecase`: `smart_capitalize`, `smart_capitalize!` (with `!` suffix for mutating methods)
- Helper functions in scripts are defined with `functionname()` pattern

**Functions (Bash):**
- snake_case for function names
- Example from `llmcat`: `show_help()`, `detect_os()`, `find_root()`, `parse_gitignore()`
- Local variables prefixed with `local` keyword when needed

**Variables (Shell):**
- UPPERCASE for constants/configuration (e.g., `CLIP_CMD`, `VERSION`, `QUIET`, `DEBUG`)
- lowercase for temporary/working variables
- Example from `llmcat`: `CLIP_CMD=""`, `VERSION="1.0.0"`, `gitignore_pattern=""`, `target`

**Variables (Ruby):**
- snake_case for local variables and instance variables
- UPPERCASE for constants
- Frozen string literals enabled via `# frozen_string_literal: true` at top of files

## Code Style

**Formatting:**
- EditorConfig defines project-wide standards: `.editorconfig`
- Default indentation: 2 spaces for most file types
- Go files: Tab indentation (exception in `.editorconfig`)
- Elm files: 4-space indentation (exception in `.editorconfig`)

**Linting:**
- Vim/Neovim uses EditorConfig for style consistency
- No explicit linter config files found (pre-commit hooks absent)
- Ruby files: Use `frozen_string_literal: true` pragma when appropriate (e.g., `darkwing`, `titlecase`, `nvim-update-plugins`)

**Whitespace:**
- Trailing whitespace trimmed (EditorConfig rule)
- UTF-8 charset enforced
- Unix line endings (LF)
- Final newline required on all files (EditorConfig rule)
- Tab characters converted to spaces (except Go and Makefile)

## Import Organization

**Ruby:**
- Standard library imports at top
- Example from `repo2md`: `require 'open3'`
- Example from `herald-crosswords`: Multiple requires followed by code
- Conditional requires wrapped in begin/rescue for optional dependencies
- Example from `irbrc`: Silently handle missing gems with rescue LoadError

**Bash:**
- No explicit imports; uses `source` for file inclusion
- Example from nvim init.vim: `source ~/.config/nvim/languages/elm.vim`
- Standard utilities used directly (grep, find, sed, awk)

**Vim:**
- Plugin manager integration via minpac
- Function-based conditional loading (PackInit pattern in `init.vim`)
- Language-specific configs sourced separately: `languages/` directory
- Plugin configs sourced separately: `plugins/` directory

## Error Handling

**Ruby:**
- begin/rescue/end blocks for exception handling
- Example from `herald-crosswords`: rescue OpenURI::HTTPError with message logging
- Example from `repo2md`: Capture exit status with `Open3.capture3`
- Silent rescue patterns: `rescue LoadError` in `irbrc` with comment `# OMNOMNOM I LOVE EXCEPTIONS`
- Status checking: `unless status.success?` pattern common
- Example: `unless status.success?` in repo2md with early exit

**Bash:**
- `set -eo pipefail` at top of scripts for safe execution (in `llmcat`)
- Exit codes checked explicitly in conditionals
- Error messages sent to STDERR: `>&2` suffix
- Error handling examples:
  - File existence checks: `[ -f "$file" ]`, `[ -d "$dir" ]`
  - Command availability: `command -v $cmd >/dev/null 2>&1`
  - Early exit on errors: `exit 1` after error message

## Logging

**Framework:** No logging framework; uses native output

**Bash (llmcat):**
- STDERR for messages: `>&2` suffix
- Example: `echo "Error: pbcopy not found" >&2`
- Conditional debug output with `debug()` function when `DEBUG="true"`
- Informational output to STDOUT: `echo "message"`
- File count feedback: `echo "Copied $file_count file(s) to clipboard" >&2`

**Ruby:**
- Direct `puts` for normal output
- `puts` with `$stderr` context for errors (implicit via shell redirect)
- Example from `herald-crosswords`: `puts "Downloading %s" % url`
- Silent operations when not needed (no output unless explicitly `puts`)

**Vim:**
- No logging present; configuration-only

## Comments

**When to Comment:**
- Minimal comments; code is typically self-documenting
- Comments used for non-obvious behavior or configuration
- Section markers using triple-brace fold markers: `" {{{ Section Name` and `" }}}`
- Example from `init.vim`: Organized into sections like `" Preamble {{{`, `" TTY Performance {{{`

**Ruby Comments:**
- Single-line comments with `#`
- Inline comments explaining regex or complex logic
- Example from `titlecase`: `# note: word could contain non-word characters!`
- License/attribution comments at top of files (rare)

**Bash Comments:**
- Shebang at top: `#!/bin/bash`
- Section headers with `# Comment` format
- Comments above complex functions explaining purpose

**JSDoc/TSDoc:**
- Not applicable; no TypeScript/JavaScript in main codebase

## Function Design

**Size:**
- Functions kept small and focused
- Largest functions in `llmcat` (351 lines total): split into logical units like `process_file()`, `process_dir()`, `run_fzf()`
- Typical function size: 10-30 lines

**Parameters:**
- Bash: Functions receive arguments via `"$1"`, `"$2"`, or `"${@}"` for all args
- Ruby: Methods use standard parameter list syntax
- Local variables in Bash declared with `local` keyword

**Return Values:**
- Bash: Functions return via exit code (0 success, 1+ failure) or stdout capture
- Ruby: Implicit return of last expression (idiomatic)
- Example from `repo2md`: Return file object or nil for conditional flows

## Module Design

**Exports:**
- No module system in use
- Bash scripts are standalone executables in `bin/`
- Ruby scripts execute immediately with `#!/usr/bin/env ruby` shebang

**File Organization:**
- Vim/Neovim: Plugin configs organized by plugin (fzf, nerdtree, etc.) and language (ruby, golang, elm)
- Location: `~/.config/nvim/plugins/` and `~/.config/nvim/languages/`
- Each plugin/language gets its own `.vim` file loaded via `source` in `init.vim`

**Barrel Files:**
- Not used; no module system

---

*Convention analysis: 2026-02-03*
