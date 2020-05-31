#!/usr/bin/env sh

# Load settings for i3
# Set terminal for i3-sensible-terminal
export TERMINAL=$(which urxvt256c || which iterm)
# Set urxvt perl libraries path
export URXVT_PERL_LIB="$HOME/.local/src/urxvt-perls/deprecated/:$HOME/.local/src/urxvt-perls/"
# load urxvt config
xrdb -merge "$HOME/.config/rxvt/config"
# use caps lock as ctrl
setxkbmap -option ctrl:nocaps
# use left ctrl as escape
xmodmap -e "keycode 37 = Escape NoSymbol Escape"

