# UTF-8 Support
setopt COMBINING_CHARS

# Homebrew path support
if command -v /usr/local/bin/brew >/dev/null 2>&1; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
