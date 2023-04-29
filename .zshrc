###
# zsh setup
###

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# In zsh, $path is an array with the values of $PATH, setting -U ensures it
# only contains unique entries
typeset -U path=("$path[@]")

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
if command -v brew >/dev/null 2>&1 && [ -n "$ZSH_VERSION" ]; then
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
  alias icat="kitty +kitten icat"
  alias u="kitty +kitten unicode_input"
  # handle remote server not being aware of kitty and breaking
  alias ssh-kitty="kitty +kitten ssh"
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

# Local installations; add to front
path[1,0]="$HOME/.local/bin"

# Man files
if command -v man >/dev/null 2>&1; then
  if ! [ "$MANPATH" ]; then
    export MANPATH="$(man -w)"
  fi
  if ! echo $MANPATH | grep -q "$HOME/.local/share/man"; then
    MANPATH="$HOME/.local/share/man:$MANPATH"
  fi
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
## npm packages
if command -v npm >/dev/null 2>&1 && [ -d "$HOME/.npm/bin" ] 2>&1; then
  path+=("$HOME/.npm/bin")
fi
## pnpm packages
if command -v pnpm >/dev/null 2>&1 && pnpm -g bin >/dev/null 2>&1; then
  path+=("$(pnpm -g bin 2>/dev/null)")
elif command -v pnpm >/dev/null 2>&1; then
  # call again to get error message
  # If we print the error message above, when the command exits successfully but
  # the bin path isn't in the PATH yet, you'll get an error like:
  # npm ERR! bin (not in PATH env variable)
  # But this isn't helpful, because we're calling the command in order to put it
  # in the PATH in the first place
  pnpm -g bin
fi
## n
if command -v n >/dev/null 2>&1; then
  export N_PREFIX="$HOME/.n"
  path+=("$N_PREFIX/bin")
fi

# Ruby
if command -v gem >/dev/null 2>&1; then
  export GEM_HOME="$HOME/.gem"
  path+=("$GEM_HOME/bin")
fi

# Go
## GVM resets GOPATH so it is setup first
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
if command -v go >/dev/null 2>&1; then
  export GOPATH=$HOME/.go
  path+=("$GOPATH/bin")
  ## Modules; required for 1.11 through 1.12
  export GO111MODULE=on
fi

# Python
## Set python3 as python if default python is not 3
if ! [[ "$(python -V 2>/dev/null)" =~ "Python 3" ]] && command -v python3 >/dev/null 2>&1; then
  alias python="/usr/bin/env python3"
fi
alias pip="python -m pip"
export PYTHON_BASE="$(python -m site --user-base)"
export PYTHON_SITE="$(python -m site --user-site)"
path+=("$PYTHON_BASE/bin")

# Rust / Cargo
if command -v cargo >/dev/null 2>&1; then
  path+=("$HOME/.cargo/bin")
fi

# Composer / PHP
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc
if command -v composer >/dev/null 2>&1; then
  export COMPOSER_HOME="$HOME/.config/composer"
  path+=("$COMPOSER_HOME/vendor/bin")
fi
if command -v php >/dev/null 2>&1; then
  alias php="/usr/bin/env php -c $HOME/.config/php/php.ini"
fi

# OpenJDK on macOS
if [ -d "/usr/local/opt/openjdk/bin" ]; then
  path+=("/usr/local/opt/openjdk/bin")
fi

# Docker desktop CLI on macOS
if [ -d "$HOME/.docker/bin" ]; then
  path+=("$HOME/.docker/bin")
fi

##
# User configuration
###

## GPG
if command -v tty >/dev/null 2>&1; then
  export GPG_TTY="$(tty)"
fi

# Tmux
# Force it to believe the terminal supports 256 colors
if command -v tmux >/dev/null 2>&1; then
  alias tmux="/usr/bin/env tmux -2"
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# make less more friendly for non-text input files, see lesspipe(1)
if command -v lesspipe >/dev/null 2>&1; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

if command -v exa >/dev/null 2>&1; then
  # Use lsd as ls alias
  alias ls="exa --color=auto --icons --group-directories-first"
else
  # enable color support of ls and also add handy aliases
  if command -v dircolors >/dev/null 2>&1; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  fi
  alias ls="ls --color=auto"
fi

# colored GCC warnings and errors
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

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
  POWERLINE_VIM="/usr/share/vim/vimfiles/"
else
  POWERLINE_VIM="$POWERLINE_PYTHON_BINDINGS/vim/"
fi
export POWERLINE_TMUX="/usr/share/tmux/powerline.conf";
if ! [ -f "$POWERLINE_TMUX" ]; then
  POWERLINE_TMUX="$POWERLINE_PYTHON_BINDINGS/tmux/powerline.conf"
  if ! [ -f "$POWERLINE_TMUX" ]; then
    # Handle case where tmux config isn't installed
    POWERLINE_TMUX="/tmp/powerline.conf"
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
# Checks the tags for the latest release. Removes leading `v` from tag names and
# strips invalid JSON that comes back from the GitHub API
# https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#releases
# https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#tags
get-latest-github() {
  if ! command -v jq >/dev/null; then
    # can't confirm version without jq
    return 1
  fi
  local OWNER="$1"
  local REPO="$2"
  if command -v gh >/dev/null 2>&1; then
    # Use gh if available
    local TAG_JSON="$(gh api repos/$OWNER/$REPO/tags)"
  else
    # otherwise fall back to curl
    local TAG_JSON="$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$OWNER/$REPO/tags")"
  fi
  if [ "$?" -ne 0 ]; then
    # curl error
    return 1
  fi
  # return latest tag
  echo "$TAG_JSON" | tr '\r\n' ' ' | jq -r '.[].name' | sed 's/^v//' | grep -v '-' | sort --version-sort --reverse | head -n 1
  return 0
}

# Check if ansible requirements are latest
is-latest-ansible-requirements() {
  if ! command -v jq >/dev/null; then
    # can't confirm version without jq
    return 1
  fi
  local REQUIREMENT_NAMESPACES=()
  local REQUIREMENTS=()
  local REPO_OVERRIDES=()
  # ansible.posix
  REQUIREMENT_NAMESPACES+=("ansible")
  REQUIREMENTS+=("posix")
  REPO_OVERRIDES+=("")
  # ansible.windows
  REQUIREMENT_NAMESPACES+=("ansible")
  REQUIREMENTS+=("windows")
  REPO_OVERRIDES+=("")
  # chocolatey.chocolatey
  REQUIREMENT_NAMESPACES+=("chocolatey")
  REQUIREMENTS+=("chocolatey")
  REPO_OVERRIDES+=("chocolatey/chocolatey-ansible")
  # community.general
  REQUIREMENT_NAMESPACES+=("community")
  REQUIREMENTS+=("general")
  REPO_OVERRIDES+=("")
  # community.windows
  REQUIREMENT_NAMESPACES+=("community")
  REQUIREMENTS+=("windows")
  REPO_OVERRIDES+=("")

  for ((i = 1; i <= $#REQUIREMENTS; i++)); do
    local REQUIREMENT="${REQUIREMENTS[$i]}"
    local REQUIREMENT_NAMESPACE="${REQUIREMENT_NAMESPACES[$i]}"
    local REPO_OVERRIDE="${REPO_OVERRIDES[$i]}"
    local LATEST_RELEASE=""
    # in both cases, remove leading `v` if present
    if [ -n "$REPO_OVERRIDE" ]; then
      # split repo override by slash and pass as owner/repo arguments to latest
      # release
      LATEST_RELEASE="$(get-latest-github $(echo $REPO_OVERRIDE | awk '{split($0,a,"/"); print a[1],a[2]}') | sed 's/^[vV]*//g')"
    else
      LATEST_RELEASE="$(get-latest-github ansible-collections $REQUIREMENT_NAMESPACE.$REQUIREMENT | sed 's/^[vV]*//g')"
    fi
    if [ "$?" -ne 0 ]; then
      >&2 echo "$REQUIREMENT_NAMESPACE.$REQUIREMENT could not get latest release"
      return 1
    fi
    if ! [ -f "$HOME/.ansible/collections/ansible_collections/$REQUIREMENT_NAMESPACE/$REQUIREMENT/MANIFEST.json" ]; then
      >&2 echo "$REQUIREMENT_NAMESPACE.$REQUIREMENT could not find current release"
      return 1
    fi
    # remove leading `v` if present
    local CURRENT_VERSION="$(cat "$HOME/.ansible/collections/ansible_collections/$REQUIREMENT_NAMESPACE/$REQUIREMENT/MANIFEST.json" | jq -r '.collection_info.version' | sed 's/^[vV]*//g')"
    # final check
    if [ "$LATEST_RELEASE" != "$CURRENT_VERSION" ]; then
      >&2 echo "$REQUIREMENT_NAMESPACE.$REQUIREMENT non latest, have $CURRENT_VERSION want $LATEST_RELEASE"
      return 1
    fi
  done
  return 0
}

# Fetch a config file from expected locations
fetch_config_file() {
  local FILE="$1"
  # Check for local config override,
  # per xdg specification
  # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
  local POSSIBLE_CONFIG_DIRS=()
  if [ -n "$XDG_CONFIG_HOME" ]; then
    POSSIBLE_CONFIG_DIRS+=("$XDG_CONFIG_HOME")
  else
    POSSIBLE_CONFIG_DIRS+=("$HOME/.config")
  fi
  if [ -z "$XDG_CONFIG_DIRS" ]; then
    POSSIBLE_CONFIG_DIRS+=("/etc/xdg")
  else
    # loop through XDG_CONFIG_DIRS
    local IFS=":"
    local XDG_CONFIG_DIR=""
    for XDG_CONFIG_DIR in $XDG_CONFIG_DIRS; do
      POSSIBLE_CONFIG_DIRS+=("$XDG_CONFIG_DIR")
    done
  fi
  local POSSIBLE_CONFIG_DIR=""
  for POSSIBLE_CONFIG_DIR in ${POSSIBLE_CONFIG_DIRS[@]}; do
    if [ -f "$POSSIBLE_CONFIG_DIR/$FILE" ]; then
      echo "$POSSIBLE_CONFIG_DIR/$FILE"
      return 0
    fi
  done
  # not found
  return 1
}

# remove previous update alias (replaced with function below)
unalias update 2>/dev/null

# update command
# usage:
# ```sh
# update [host]
# ```
# host - A specific host to update, updates all if not provided
update() {
  local HOST="$1"
  local DEPENDENCIES=()
  DEPENDENCIES+=("yadm")
  DEPENDENCIES+=("ansible-galaxy")
  DEPENDENCIES+=("ansible-playbook")
  for DEPENDENCY in ${DEPENDENCIES[@]}; do
    if ! command -v "$DEPENDENCY" >/dev/null; then
      >&2 echo "Please install $DEPENDENCY before running this script"
      return 1
    fi
  done
  if [ -z "$IN_UPDATE" ]; then
    # Authenticate with gh if not already
    if command -v gh >/dev/null 2>&1; then
      if ! gh auth status --hostname github.com >/dev/null 2>&1; then
        gh auth login --hostname github.com
      fi
    fi

    # get latest zshrc and load it
    yadm pull origin main
    source "$HOME/.zshrc"
    IN_UPDATE="1"
    update "$HOST"
    return 0
  fi
  unset IN_UPDATE

  # run updates
  local ANSIBLE_DIR="$HOME/Projects/configuration/ansible"
  local INVENTORY_FILE="$ANSIBLE_DIR/inventory.yaml"
  local INVENTORY_OVERRIDE="$(fetch_config_file "/ansible/hosts")"
  if [ -n "$INVENTORY_OVERRIDE" ]; then
    INVENTORY_FILE="$INVENTORY_OVERRIDE"
  fi
  is-latest-ansible-requirements || ansible-galaxy collection install \
    --force-with-deps \
    --requirements-file "$ANSIBLE_DIR/requirements.yaml"
  if [ -n "$HOST" ]; then
    ansible-playbook \
      --ask-vault-pass \
      --inventory-file "$INVENTORY_FILE" \
      --limit "$HOST" \
      "$ANSIBLE_DIR/playbook.yaml"
  else
    ansible-playbook \
      --ask-vault-pass \
      --inventory-file "$INVENTORY_FILE" \
      "$ANSIBLE_DIR/playbook.yaml"
  fi
}

# Set editor
if command -v hx >/dev/null 2>&1; then
  export EDITOR="$(which hx)"
elif command -v vim >/dev/null 2>&1; then
  export EDITOR="$(which vim)"
elif command -v vi >/dev/null 2>&1; then
  export EDITOR="$(which vi)"
fi

# Editor alias
edit() {
  if command -v "$EDITOR" >/dev/null 2>&1; then
    $EDITOR "$@"
  elif command -v hx >/dev/null 2>&1; then
    hx "$@"
  elif command -v vim >/dev/null 2>&1; then
    vim "$@"
  elif command -v vi >/dev/null 2>&1; then
    vi "$@"
  else
    >&2 echo "No suitable editor found"
  fi
}

# Restart macOS sshd
restart-macos-sshd() {
  if command -v launchctl >/dev/null 2>&1; then
    sudo launchctl unload  /System/Library/LaunchDaemons/ssh.plist && \
      sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist
  fi
}

# Attach tmux when ssh session starts, exit when it exits
if command -v tmux >/dev/null 2>&1; then
  if ([ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]) \
    && command -v tmux &> /dev/null \
    && [ -n "$PS1" ] \
    && [[ ! "$TERM" =~ screen ]] \
    && [[ ! "$TERM" =~ tmux ]] \
    && [ -z "$TMUX" ]; then
    exec tmux new -A -s default && exit
  fi
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

## Get submodules to match latest committed commit in parent repo
alias fix-submodules="git submodule update --recursive -f"

# Includes, set this last so it can override other settings
INCLUDES_DIR="$HOME/.local/share/includes" && \
  test -d "$INCLUDES_DIR" && \
  INCLUDES=("${(@f)$(find -L "$HOME/.local/share/includes" -name '*.zsh')}") && \
  for INCLUDE in $INCLUDES; do
    source "$INCLUDE"
  done
