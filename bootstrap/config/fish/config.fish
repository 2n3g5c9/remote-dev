set fish_greeting ""

set -gx TERM xterm-256color
set -gx EDITOR nvim

# Theme
theme_gruvbox dark medium

# Aliases
source ~/.aliases

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

starship init fish | source
