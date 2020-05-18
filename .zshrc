###
# zsh setup
###

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# load bashcompinit for some old bash completions
autoload bashcompinit && bashcompinit

# Enable advanced auto completion
if command -v brew >/dev/null 2>&1 && brew list zsh >/dev/null 2>&1; then
  # Brew install zsh to "insecure" directories, -i silently ignores the results
  # of those security checks
  autoload -Uz compinit && compinit -i
else
  autoload -Uz compinit && compinit
fi

# Enable command correction
setopt CORRECT
setopt CORRECT_ALL

# Where should the history file be saved
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

# Size of history file
SAVEHIST=5000
HISTSIZE=2000

# share history across multiple zsh sessions
setopt SHARE_HISTORY

# append to history
setopt APPEND_HISTORY

# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY

# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST

# do not store duplications
setopt HIST_IGNORE_DUPS

#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS

# removes blank lines from history
setopt HIST_REDUCE_BLANKS

# Enable additional features in history
setopt EXTENDED_HISTORY

# Show `!!` command before executing
setopt HIST_VERIFY

# You may need to manually set your language environment
export LANG=en_US.UTF-8

###
# Path setup
###

# Brew installed applications
if command -v brew >/dev/null 2>&1; then
  export PATH="/usr/local/sbin:$PATH"
fi

# GNU Coreutils on macOS
if [ -d "/usr/local/opt/coreutils/libexec/gnubin" ]; then
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi

# Local installations
export PATH=$HOME/.local/bin:$PATH

# Man files
export MANPATH="/usr/local/man:$MANPATH"
export MANPATH=$HOME/.local/share/man:$MANPATH

###
# Languate setup
###

# Node
## npm packages
export PATH=$HOME/.npm/bin:$PATH

# Ruby
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"

# Go
## GVM resets GOPATH so it is setup first
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH

# Python
alias pip="/usr/bin/env pip3"
alias python="/usr/bin/env python3"
export PYTHON_BASE="$(python -m site --user-base)"
export PYTHON_SITE="$(python -m site --user-site)"
export PATH="$PATH:$PYTHON_BASE/bin"

# Rust / Cargo
export PATH=$HOME/.cargo/bin:$PATH

# Composer / PHP
export COMPOSER_HOME="$HOME/.config/composer"
export PATH="$PATH:$COMPOSER_HOME/vendor/bin"
alias php="/usr/bin/env php -c $HOME/.config/php/php.ini"

##
# User configuration
###

## GPG
export GPG_TTY=$(tty)

# Tmux
# Force it to believe the terminal supports 256 colors
alias tmux='tmux -2'

# Vim
export EDITOR="$(which vim)"

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# make less more friendly for non-text input files, see lesspipe(1)
if command -v lesspipe >/dev/null 2>&1; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

# enable color support of ls and also add handy aliases
if command -v dircolors >/dev/null 2>&1; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
alias ls='ls --color=auto'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# color for grep
export GREP_OPTIONS="--color=auto"

# Powerline
if pip show powerline-status >/dev/null 2>&1 && command -v powerline-daemon >/dev/null 2>&1; then
  powerline-daemon -q
  . "$(python -m site --user-site)/powerline/bindings/zsh/powerline.zsh"
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

