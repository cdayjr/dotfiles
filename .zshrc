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

# Set up yadm completions
if [ -d /usr/share/doc/yadm/completion/zsh ]; then
  fpath=(/usr/share/doc/yadm/completion/zsh $fpath)
fi

# Enable advanced auto completion
if command -v brew >/dev/null 2>&1 && brew list zsh >/dev/null 2>&1; then
  # Brew install zsh to "insecure" directories, -i silently ignores the results
  # of those security checks
  autoload -Uz compinit && compinit -i
else
  autoload -Uz compinit && compinit
fi

# Setup kitty terminal features
if command -v kitty >/dev/null 2>&1 && [ "$TERM" = "xterm-kitty" ]; then
  kitty + complete setup zsh | source /dev/stdin
  alias c="kitty +kitten clipboard"
  alias d="kitty +kitten diff"
  alias i="kitty +kitten icat"
  alias u="kitty +kitten unicode_input"
fi

# enable vim mode
set -o vi

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
if ! [ "$MANPATH" ]; then
  export MANPATH="$(man -w)"
fi
if ! echo $MANPATH | grep -q "$HOME/.local/share/man"; then
  export MANPATH="$HOME/.local/share/man:$MANPATH"
fi


###
# Autocompletion setup
###

# Kubernetes
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

# Helm
if command -v helm >/dev/null 2>&1; then
  source <(helm completion zsh)
fi

# Minikube
if command -v minikube >/dev/null 2>&1; then
  source <(minikube completion zsh)
fi

###
# Languate setup
###

# Node
## pnpm packages
export PATH="$HOME/.npm/pnpm-global/3/node_modules/.bin:$PATH"
## n
if command -v n >/dev/null 2>&1; then
  export N_PREFIX="$HOME/.n"
  export PATH="$N_PREFIX/bin:$PATH"
fi

# Ruby
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"

# Go
## GVM resets GOPATH so it is setup first
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH

## Modules; required for 1.11 through 1.12
export GO111MODULE=on

# Python
## Set python3 as python if default python is not 3
if ! [[ "$(python -V 2>/dev/null)" =~ "Python 3" ]] && command -v python3 >/dev/null 2>&1; then
  alias python="/usr/bin/env python3"
fi
alias pip="python -m pip"
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

if command -v exa >/dev/null 2>&1; then
  # Use lsd as ls alias
  alias ls='exa --color=auto --icons --group-directories-first'
else
  # enable color support of ls and also add handy aliases
  if command -v dircolors >/dev/null 2>&1; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  fi
  alias ls='ls --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# color for grep
alias grep="grep --color=auto"

# Powerline
if [ -d "/usr/share/powerline" ]; then
  export POWERLINE_PYTHON_BINDINGS="/usr/share/powerline"
else
  export POWERLINE_PYTHON_BINDINGS="$PYTHON_SITE/powerline/bindings"
fi
export POWERLINE_VIM=""
if [ -f "/usr/share/vim/vimfiles/plugin/powerline.vim" ]; then
  export POWERLINE_VIM="/usr/share/vim/vimfiles/"
else
  export POWERLINE_VIM="$POWERLINE_PYTHON_BINDINGS/vim/"
fi
export POWERLINE_TMUX="/usr/share/tmux/powerline.conf";
if ! [ -f "$POWERLINE_TMUX" ]; then
  export POWERLINE_TMUX="$POWERLINE_PYTHON_BINDINGS/tmux/powerline.conf"
  if ! [ -f "$POWERLINE_TMUX" ]; then
    # Handle case where tmux config isn't installed
    export POWERLINE_TMUX="/tmp/powerline.conf"
    touch "$POWERLINE_TMUX"
  fi
fi
if pip show powerline-status >/dev/null 2>&1 && command -v powerline-daemon >/dev/null 2>&1; then
  powerline-daemon -q
  . "$POWERLINE_PYTHON_BINDINGS/zsh/powerline.zsh"
fi

# Support for vagrant access outside of a WSL environment
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"

# Get latest release of a github repo
# See
# https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#releases
get-latest-github() {
  if ! command -v jq >/dev/null; then
    # can't confirm version without jq
    return 1
  fi
  local OWNER="$1"
  local REPO="$2"
  local RELEASE_JSON="$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$OWNER/$REPO/releases/latest")"
  if [ "$?" -ne 0 ]; then
    # curl error
    return 1
  fi
  # return release name
  echo "$RELEASE_JSON" | jq -r '.tag_name'
  return 0
}

# Check if ansible communtiy.general is latest
is-latest-community-general() {
  if ! command -v jq >/dev/null; then
    # can't confirm version without jq
    return 1
  fi
  local LATEST_RELEASE="$(get-latest-github ansible-collections community.general)"
  if [ "$?" -ne 0 ]; then
    # could not get latest release, always update
    return 1
  fi
  if ! [ -f "$HOME/.ansible/collections/ansible_collections/community/general/MANIFEST.json" ]; then
    # could not find current release, always update
    return 1
  fi
  local CURRENT_VERSION="$(cat "$HOME/.ansible/collections/ansible_collections/community/general/MANIFEST.json" | jq -r '.collection_info.version')"
  # final check
  test "$LATEST_RELEASE" = "$CURRENT_VERSION"
  return "$?"
}

# remove previous update alias (replaced with function below)
unalias update 2>/dev/null

## update command
update() {
  if ! command -v yadm >/dev/null; then
    >&2 echo "Please install yadm before running this script"
    return 1
  fi
  if ! command -v ansible-galaxy >/dev/null; then
    >&2 echo "Please install ansible before running this script"
    return 1
  fi
  if ! command -v ansible-playbook >/dev/null; then
    >&2 echo "Please install ansible before running this script"
    return 1
  fi
  if [ -z "$IN_UPDATE" ]; then
    # get latest zshrc and load it
    yadm pull origin main
    source "$HOME/.zshrc"
    IN_UPDATE="1"
    update
    return 0
  fi
  unset IN_UPDATE
  # run updates
  local ANSIBLE_DIR="$HOME/Projects/configuration/ansible"
  is-latest-community-general || ansible-galaxy collection install \
    --force-with-deps \
    --requirements-file "$ANSIBLE_DIR/requirements.yaml"
  ansible-playbook \
    --inventory-file "$ANSIBLE_DIR/inventory.yaml" \
    --ask-become-pass \
    "$ANSIBLE_DIR/playbook.yaml"
}

# Includes
INCLUDES=($(compgen -G "$HOME/.local/share/includes/**/*.zsh")) && \
  for INCLUDE in $INCLUDES; do
    source "$INCLUDE"
  done

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

## Get submodules to match latest committed commit in parent repo
alias fix-submodules="git submodule update --recursive -f"
