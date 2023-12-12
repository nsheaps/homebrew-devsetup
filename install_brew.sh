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
      echo "✅ already in $1"
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
HOMEBREW_PREFIX=$(brew --prefix)
enforce-line-in-file ~/.bashrc "eval \"\\$($HOMEBREW_PREFIX/bin/brew shellenv)\""
enforce-line-in-file ~/.zshrc "eval \"\\$($HOMEBREW_PREFIX/bin/brew shellenv)\""
enforce-line-in-file ~/.profile "eval \"\\$($HOMEBREW_PREFIX/bin/brew shellenv)\""
enforce-line-in-file /etc/profile "eval \"\\$($HOMEBREW_PREFIX/bin/brew shellenv)\""

# if secure_path is set, add the brew path to it, $HOMEBREW_PREFIX/sbin:$HOMEBREW_PREFIX/bin
sudo -v -p "🔒 requesting sudo access for protected file /etc/sudoers"
if sudo grep -qF "secure_path" /etc/sudoers; then\
  echo "🍺 Ensuring sudo can use brew-installed packages"
  # secure_path exists
  if sudo grep -qF "secure_path.*$HOMEBREW_PREFIX/sbin:$HOMEBREW_PREFIX/bin" /etc/sudoers; then
    # brew path already in secure_path
    echo "✅ brew path already in secure_path"
  else
    # brew path not in secure_path
    echo "🔒 adding brew path to secure_path"
    sudo sed -i "s/secure_path=\"/secure_path=\"$HOMEBREW_PREFIX\/sbin:$HOMEBREW_PREFIX\/bin:/g" /etc/sudoers
    echo "✅ brew path added to secure_path"
  fi
# else
#   # secure_path doesn't exist
#   echo "🔒 adding secure_path to sudoers"
#   sudo sed -i "s/Defaults    env_reset/Defaults    env_reset,secure_path=\"$BREW_PREFIX\/sbin:$BREW_PREFIX\/bin\"/g" /etc/sudoers
#   echo "✅ secure_path added to sudoers"
fi 

echo "🍺 Brew setup complete."
