#! /usr/bin/env bash

if ! command -v brew >/dev/null; then
  # brew is not installed
  # Install brew - Keep up to date with homepage script here: https://brew.sh/
  echo "🍺 Installing brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # If you're on linux, add the necessary parts
  ## sets up brew on the CLI for getting `brew --prefix` later
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "✅ Brew installed."
else
  echo "✅ Brew already installed."
fi

echo "ℹ️  Brew version: $(brew --version)"
echo "ℹ️  Brew prefix: $(brew --prefix)"

function line-exists-in-file() {
  # $1 = file
  # $2 = line
  # todo: make this platform independent, macos and linux have different grep
  if [ ! -f "$1" ]; then
    # file doesn't exist, so line can't exist
    return 1
  fi
  if grep -qxF "$2" "$1"; then
    # line exists
    return 0
  else
    # line doesn't exist
    return 1
  fi
}

function enforce-line-in-file() {
  # $1 = file
  # $2 = line
  if [ -f "$1" ]; then
    if line-exists-in-file "$1" "$2"; then
      echo "✅ already in to $1"
    else
      # if the file is write protected, use sudo
      if [ ! -w "$1" ]; then
        # ensure sudo access
        sudo -v -p "🔒 requesting sudo access for protected file $1"
        echo "🔒 adding to $1 with sudo"
        echo "$2" | sudo tee -a "$1" >/dev/null
      else 
        # echo "adding to $1"
        echo "$2" >> "$1"
      fi
      echo "✅ added to $1"
    fi
  else
    echo "❓ $1 does not exist"
  fi
}

echo "🍺 Adding brew shellenvs..."
BREW_PREFIX=$(brew --prefix)
enforce-line-in-file ~/.bashrc "eval \"\\$($BREW_PREFIX/bin/brew shellenv)\""
enforce-line-in-file ~/.zshrc "eval \"\\$($BREW_PREFIX/bin/brew shellenv)\""
enforce-line-in-file ~/.profile "eval \"\\$($BREW_PREFIX/bin/brew shellenv)\""
enforce-line-in-file /etc/profile "eval \"\\$($BREW_PREFIX/bin/brew shellenv)\""

echo "🍺 Brew setup complete."
