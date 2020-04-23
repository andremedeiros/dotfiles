# Dotfiles

This is my dotfiles repo. There are many others, but this one is mine.

The dotfiles here are managed with [Thoughtbot's rcm](https://github.com/thoughtbot/rcm)

## Installation

```
xcode-select --install
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
* <kbd>[leader]-z</kbd> Toggles zoom on active pane
* <kbd>[leader]-\\</kbd> Toggles project navigation
* <kbd>H</kbd> Move to beginning of line
* <kbd>L</kbd> Move to end of line
* <kbd>/</kbd> <kbd>/</kbd> Stop searching
* <kbd>[leader]-doc</kbd> Opens documentation for word under cursor

#### Git status

* <kbd>ctrl+n</kbd> / <kbd>ctrl+p</kbd> Navigates through the files in the status buffer
* <kbd>-</kbd> Stages / unstages a file
* <kbd>C</kbd> Commit

#### Go

* <kbd>[leader]-god</kbd> Go to definition
* <kbd>[leader]-gor</kbd> Run the current file
* <kbd>[leader]-got</kbd> Run tests
* <kbd>[leader]-gotf</kbd> Run tests (current function)

### Tmux

Leader is bound to <kbd>Ctrl+Space</kbd>

#### Splitting

* <kbd>[leader]-|</kbd> Split vertically
* <kbd>[leader]--</kbd> Split horizontally

#### Navigation

* <kbd>[leader]-h</kbd> Navigate to left pane
* <kbd>[leader]-l</kbd> Navigate to right pane
* <kbd>[leader]-k</kbd> Navigate to pane above
* <kbd>[leader]-j</kbd> Navigate to pane below
* <kbd>[leader]-w</kbd> Navigate windows
* <kbd>[leader]-s</kbd> Navigate sessions
* <kbd>[leader]-[</kbd> Enter scroll mode (<kbd>q</kbd> quits)

#### Session

* <kbd>[leader]-c</kbd> New window
* <kbd>[leader]-z</kbd> Zoom on current pane

## Shortcuts

TBD

## Guides

- [fd](https://github.com/sharkdp/fd)
