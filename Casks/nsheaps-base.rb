cask 'nsheaps-base' do
  name 'nsheaps-base'
  desc 'A metaformula for installing the base applications for Nathan Heaps < nsheaps[at]gmail[dot]com >'
  homepage 'http://github.com/nsheaps/homebrew-devsetup'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  sha256 'b14702dd54ea5c48d2ebeb6425015c14794159a6b9d342178c81d2f2e79ed2db'
  version '1.0.27' # bump me if you want people to re-install these things, like if the list changed.
  ### WHAT IS THIS
  # Running the quick start script will:
  # - install homebrew if not already installed
  # - install this cask
  # - install a set of base formulae and casks via brew (requires app not be installed)
  # - install the `dotfiles` formula, which wires the shell config into $HOME
  #   (antidote plugins, mise tools, aliases) automatically via its post_install
  # It does not:
  # - softwareupdate --install-rosetta (you must do this manually)
  # - install docker-desktop (they're really anti casks because of permissions)
  # - open all the apps/tools and log you in (you must do this manually)
  #   - [ ] vscode
  #   - [ ] 1password desktop login
  #   - [ ] gh auth login
  #   - [ ] gh setup-git
  #   - [ ] generate gpg keys and add to github/git
  # The formula itself does not:
  # - manage anything other than brew installs for casks and formulae
  #   (rc integrations are now handled by the `dotfiles` formula dependency)
  # - work on linux (casks are not supported)
  ### QUICKSTART
  #
  # Dry run:
  # brew update && brew outdated
  #
  # Updating:
  # brew update && brew upgrade --greedy (will update all taps, then installed formulae/casks)
  #
  # Installation:
  # Run the following (copy/paste) into your shell.

  # setopt interactivecomments
  # FETCH=($(command -v curl &>/dev/null && echo 'curl -fsSL' || echo 'wget -O -'))
  # bash <($FETCH "https://raw.githubusercontent.com/nsheaps/homebrew-devsetup/HEAD/install_brew.sh")

  # then follow the instructions in the CAVEATS section

  # =====

  # stage_only true

  # system tools
  # depends_on formula: 'awscli'
  depends_on formula: 'bash'
  depends_on formula: 'ca-certificates'
  depends_on formula: 'curl'
  depends_on formula: 'wget'
  depends_on formula: 'coreutils'
  depends_on formula: 'gnupg'
  depends_on formula: 'openssl@3'
  depends_on formula: 'pstree'
  depends_on formula: 'tree'
  depends_on formula: 'tmux'

  # shell setup
  # installs the `dotfiles` CLI and auto-wires the shell config into $HOME
  depends_on formula: 'nsheaps/devsetup/dotfiles'
  depends_on formula: 'antidote' # antigen replacement, zsh package manager
  depends_on formula: 'autojump' # fuzzy path cd based on frequency of use
  depends_on formula: 'direnv' # load env files when cd-ing into a dir
  depends_on formula: 'gum' # pretty printing in shell
  depends_on formula: 'mise' # tool manager
  depends_on formula: 'thefuck' # cli execution correction advisor (helps you fix your CLI calls)

  # dev tools
  depends_on formula: 'gh'
  depends_on formula: 'git'
  depends_on formula: 'git-lfs'
  depends_on formula: 'git-extras'
  depends_on formula: 'shellcheck' # TODO: get from mise?
  depends_on formula: 'shfmt' # TODO: get from mise?
  depends_on formula: 'git-spice'

  # docker dev tooling
  depends_on formula: 'tilt'
  # depends_on formula: 'helm'
  depends_on formula: 'kubectl'

  # depends_on formula: 'mas' # mac app store cli, used later to install apps from app store
  on_linux do
    depends_on formula: 'zsh'
  end

  depends_on cask: '1password'
  depends_on cask: '1password-cli'
  depends_on cask: 'alfred' # spotlight replacement
  depends_on cask: 'loop' # window tiling manager
  # depends_on cask: 'claude' # claude desktop
  depends_on cask: 'claude-code'
  depends_on cask: 'visual-studio-code'
  depends_on cask: 'google-chrome'
  depends_on cask: 'karabiner-elements' # keyboard customizer
  # depends_on cask: 'slack'
  # depends_on cask: 'notion'
  depends_on cask: 'linear'
  depends_on cask: 'jordanbaird-ice' # menu tray organizer
  depends_on cask: 'iterm2'
  depends_on cask: 'itermai'
  depends_on cask: 'itermbrowserplugin'
  # depends_on cask: 'zoom'
  # depends_on cask: 'spotify'
  # depends_on cask: 'telegram'
  depends_on cask: 'nsheaps/devsetup/handy' # voice transcription for mac/linux

  def install
    # even though there's stuff in the brew-meta-formula, brew needs something to install or it will
    # complain about an empty installation
    system 'touch', 'trick-brew-to-install-meta-formula'
    prefix.install 'trick-brew-to-install-meta-formula'
  end

  def caveats
    <<~CAVEATS
      Shell setup is handled automatically by the `dotfiles` formula (a
      dependency of this cask). Its post_install runs `dotfiles ensure-wired`,
      which symlinks the config into $HOME and injects the managed sections into
      ~/.zshrc / ~/.zshenv / ~/.zprofile — including the antidote plugin bundle,
      the mise tool list, and the brew helper aliases. No manual ~/.zshrc edits
      or `mise use -g` are required.

      Open a new terminal (or `source ~/.zshrc`) to load it. Verify with:
        $ dotfiles check
      Re-deploy manually at any time with:
        $ dotfiles wire

      Remaining manual steps (not handled automatically):
        - softwareupdate --install-rosetta --agree-to-license
        - gh auth login && gh auth setup-git
        - generate gpg/ssh keys and add them to GitHub / 1Password
        - restart so login shells re-source at the OS level

      Handy aliases (provided by dotfiles once wired):
        $ brew-outdated     # brew update && brew outdated
        $ brew-update-all   # brew update && brew upgrade --greedy
    CAVEATS
  end
end
