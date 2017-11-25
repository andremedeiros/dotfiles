# Dotfiles

This is my dotfiles repo. There are many others, but this one is mine.

The dotfiles here are managed with [Thoughtbot's rcm](https://github.com/thoughtbot/rcm)

## Installation

```
mkdir -p ~/src/github.com/andremedeiros
git -C ~/src/github.com/andremedeiros clone https://github.com/andremedeiros/dotfiles.git
cd ~/src/github.com/andremedeiros/dotfiles
script/bootstrap
```

You can also add secret/proprietary dotfiles on your iCloud drive. Anything inside `iCloud Drive/dotfiles` will also be symlinked with the same rules as here.

## Keyboard bindings

### NeoVim

Leader is bound to <kbd>Space</kbd>

#### Editing

* <kbd>[leader]-j</kbd> List buffers
* <kbd>[leader]-p</kbd> List files
* <kbd>[leader]-t</kbd> Toggles tagbar
* <kbd>H</kbd> Move to beginning of line
* <kbd>L</kbd> Move to end of line

#### Git status

* <kbd>ctrl+n</kbd> / <kbd>ctrl+p</kbd> Navigates through the files in the status buffer
* <kbd>-</kbd> Stages / unstages a file
* <kbd>C</kbd> Commit

### Tmux

TBD

## Shortcuts

TBD
