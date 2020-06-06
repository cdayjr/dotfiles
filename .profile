#!/usr/bin/env sh

# Load settings for i3
# Set terminal for i3-sensible-terminal
if command -v urxvt256c > /dev/null; then
  export TERMINAL=$(command -v urxvt256c)
elif command -v konsole > /dev/null; then
  export TERMINAL=$(command -v konsole)
fi
# Set urxvt perl libraries path
export URXVT_PERL_LIB="$HOME/.local/src/urxvt-perls/deprecated/:$HOME/.local/src/urxvt-perls/"
# load urxvt config
if command -v xrdb >/dev/null; then
  xrdb -merge "$HOME/.config/rxvt/config"
fi
# use caps lock as ctrl
if command -v setxkbmap >/dev/null; then
  setxkbmap -option ctrl:nocaps
fi
# use left ctrl as escape
if command -v xmodmap >/dev/null; then
  xmodmap -e "keycode 37 = Escape NoSymbol Escape"
fi
# disable stty start/stop
if command -v stty >/dev/null; then
  stty start undef
  stty stop undef
fi
