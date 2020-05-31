# Load settings for i3
# Set terminal for i3-sensible-terminal
export TERMINAL=$(which urxvt256c || which iterm)
export URXVT_PERL_LIB="$HOME/.local/src/urxvt-perls/deprecated/:$HOME/.local/src/urxvt-perls/"
# load urxvt config
xrdb -merge ~/.config/rxvt/config
