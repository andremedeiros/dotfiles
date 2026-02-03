# Codebase Structure

**Analysis Date:** 2026-02-03

## Directory Layout

```
dotfiles/
├── .planning/               # GSD planning documents (generated)
├── bin/                     # Custom executable utilities
├── config/                  # Application configuration files
│   ├── aerospace/          # Window manager configuration
│   ├── code/               # VS Code settings
│   ├── fish/               # Fish shell configuration
│   ├── mise/               # Language version manager config
│   ├── nvim/               # Neovim editor configuration
│   ├── starship.toml       # Shell prompt configuration
│   └── zellij.kdl          # Terminal multiplexer config
├── gnupg/                  # GPG configuration
├── hammerspoon/            # macOS automation (Lua)
├── hooks/                  # rcm lifecycle hooks
│   ├── pre-up/            # Pre-installation setup scripts
│   └── post-up/           # Post-installation setup scripts
├── script/                 # Installation and bootstrap scripts
├── ssh/                    # SSH configuration
├── styles/                 # Vale writing style rules
├── Brewfile                # Homebrew package manifest
├── editorconfig            # Editor formatting standards
├── gitattributes           # Git file attributes
├── gitconfig               # Git configuration
├── rcrc                    # rcm configuration manifest
├── tool-versions           # Mise language version specs
├── vale.ini                # Vale linting configuration
└── README.md               # Documentation
```

## Directory Purposes

**bin:**
- Purpose: Custom CLI tools and automation scripts
- Contains: Executable shell scripts and Ruby utilities
- Key files: `llmcat`, `repo2md`, `darkwing`, `herald-crosswords`, `git-rewrite-branch`

**config/:**
- Purpose: Application configuration stored as dotfiles
- Contains: Configuration files for terminal, editors, system tools
- Key files: Multiple `config/*/` subdirectories

**config/aerospace/:**
- Purpose: Tiling window manager configuration for macOS
- Contains: Window management and keybinding rules
- Key files: Window layout definitions

**config/code/User/:**
- Purpose: VS Code editor settings and preferences
- Contains: settings.json and VSCode configuration
- Key files: `settings.json`

**config/fish/conf.d/:**
- Purpose: Fish shell initialization and configuration modules
- Contains: Individual shell configuration scripts loaded on startup
- Key files: `00-homebrew.fish`, `10-environment.fish`, `aliases.fish`, `mise.fish`, `fzf.fish`

**config/mise/:**
- Purpose: Language version manager configuration
- Contains: Settings for Mise tool
- Key files: Version and tool configuration

**config/nvim/:**
- Purpose: Neovim editor configuration
- Contains: VimL configuration, plugin specs, language-specific settings
- Key files: `init.vim`, `plugins/`, `languages/`

**config/nvim/plugins/:**
- Purpose: Neovim plugin-specific configuration
- Contains: Individual plugin setup files
- Key files: `fzf.vim`, `nerdtree.vim`, `vim-lsp.vim`, `lightline.vim`, `gitgutter.vim`, `vista.vim`, `startify.vim`

**config/nvim/languages/:**
- Purpose: Language-specific Neovim settings
- Contains: Language setup and LSP configuration
- Key files: `golang.vim`, `ruby.vim`, `elm.vim`

**gnupg/:**
- Purpose: GPG key and configuration storage
- Contains: GPG configuration files
- Key files: GPG agent configuration

**hammerspoon/:**
- Purpose: macOS automation and system integration via Hammerspoon daemon
- Contains: Lua scripts for window management, reloading, system utilities
- Key files: `init.lua`, `windows.lua`, `moonlight.lua`, `reloader.lua`

**hooks/pre-up/:**
- Purpose: Execute before rcm symlink creation
- Contains: Setup scripts for prerequisites
- Key files: `00-setup-symlinks`, `01-sync-blobs`, `02-setup-sudo`

**hooks/post-up/:**
- Purpose: Execute after rcm symlink creation
- Contains: Installation and configuration scripts run in sequence
- Key files: Numbered scripts `00-14` for different setup phases

**script/:**
- Purpose: Installation and maintenance scripts
- Contains: Bootstrap and utility scripts
- Key files: `bootstrap` (main entry point)

**ssh/:**
- Purpose: SSH client configuration
- Contains: SSH config files and control settings
- Key files: `control/` subdirectory for socket management

**styles/:**
- Purpose: Writing style rules for Vale documentation linting
- Contains: YAML configuration files defining style rules
- Key files: `alex/`, `write-good/`, `proselint/`, `Google/`, `Joblint/` style directories

## Key File Locations

**Entry Points:**
- `script/bootstrap`: Initial installation entry point
- `config/fish/conf.d/`: Shell initialization files
- `config/nvim/init.vim`: Neovim startup
- `hammerspoon/init.lua`: macOS automation startup

**Configuration:**
- `rcrc`: rcm configuration controlling symlink behavior
- `Brewfile`: Homebrew package declarations
- `tool-versions`: Language runtime versions (Mise format)
- `editorconfig`: Editor formatting standards
- `.gitignore`: Git ignored patterns
- `gitattributes`: Git file handling rules
- `gitconfig`: Git user and alias configuration

**Core Logic:**
- `hooks/pre-up/`: Prerequisite setup before symlinks created
- `hooks/post-up/`: Installation logic after symlinks created
- `bin/`: Custom utilities and CLI tools
- `config/`: Application-specific settings

**Testing:**
- No automated tests present
- Manual validation via installation process

## Naming Conventions

**Files:**
- Shell scripts: no extension (executable permissions), located in `bin/`
- Vim configuration: `.vim` extension
- Fish shell: `.fish` extension
- Lua scripts: `.lua` extension
- YAML styles: `.yml` extension
- Configuration files: contextual names (e.g., `gitconfig`, `starship.toml`)

**Directories:**
- Short, descriptive names in lowercase: `config/`, `bin/`, `hooks/`, `styles/`
- XDG Base Directory paths nested under `config/`: `config/nvim/`, `config/fish/`, `config/code/`
- Hook phases named by lifecycle: `pre-up/`, `post-up/`
- Hook scripts numbered for execution order: `00-*` runs before `01-*`

**Hook Scripts:**
- Format: `NN-descriptive-name` (two-digit number + hyphenated description)
- Numbers indicate execution order across pre-up and post-up phases
- Example: `00-setup-symlinks`, `01-sync-blobs`, `02-setup-sudo`

## Where to Add New Code

**New Utility Script:**
- Primary location: `bin/[script-name]` (executable, no extension)
- Pattern: Shell script with shebang `#!/usr/bin/env bash` or Ruby with `#!/usr/bin/env ruby`
- Access: Added to PATH via `config/fish/conf.d/10-environment.fish` path export

**New Shell Configuration:**
- Primary location: `config/fish/conf.d/[description].fish`
- Pattern: Named with priority number if order matters (e.g., `05-custom-setup.fish`)
- Sourced automatically by Fish shell startup

**New Hook:**
- Primary location: `hooks/pre-up/[NN-name]` or `hooks/post-up/[NN-name]`
- Pattern: Executable shell script with shebang
- Execution: Automatically run in numerical order by rcm

**New Application Config:**
- Primary location: `config/[app-name]/` or nested under XDG paths
- Pattern: Create subdirectory following XDG conventions
- Symlinked by rcm to `$HOME/.config/[app-name]/`

**New Language Configuration:**
- Neovim: `config/nvim/languages/[language].vim`
- Fish: `config/fish/conf.d/[description].fish`
- Add version to: `tool-versions` using Mise format

**Custom Aliases/Functions:**
- Location: `config/fish/conf.d/aliases.fish` (or new `.fish` file)
- Pattern: Use `alias` for commands, `function` for complex scripts

## Special Directories

**`.planning/codebase/`:**
- Purpose: GSD planning documents (generated)
- Generated: Yes
- Committed: Yes
- Contains: ARCHITECTURE.md, STRUCTURE.md, CONVENTIONS.md, TESTING.md, CONCERNS.md

**`hooks/`:**
- Purpose: rcm lifecycle automation
- Generated: No
- Committed: Yes
- Execution: Automatic during `rcup` installation

**`styles/.vale-config/`:**
- Purpose: Vale configuration helpers
- Generated: No
- Committed: Yes
- Contains: Style package configurations

**`ssh/control/`:**
- Purpose: SSH connection socket storage
- Generated: Yes (at runtime)
- Committed: No (contains active connections)
- Used by: SSH multiplexing

---

*Structure analysis: 2026-02-03*
