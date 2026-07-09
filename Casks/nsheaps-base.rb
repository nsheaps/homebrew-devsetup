cask 'nsheaps-base' do
  name 'nsheaps-base'
  desc 'A metaformula for installing the base applications for Nathan Heaps < nsheaps[at]gmail[dot]com >'
  homepage 'http://github.com/nsheaps/homebrew-devsetup'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  sha256 'b14702dd54ea5c48d2ebeb6425015c14794159a6b9d342178c81d2f2e79ed2db'
  version '1.0.24' # bump me if you want people to re-install these things, like if the list changed.
  ### WHAT IS THIS
  # Running the quick start script will:
  # - install homebrew if not already installed
  # - install this cask
  # - install a set of base formulae and casks via brew (requires app not be installed)
  # - set up ohmyzsh via antigen (todo: replace with antidote) and a set of plugins/themes
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
  # - manage the rc integrations
  # - manage anything other than brew installs for casks and formulae
  # - work on linux (casks are not supported)
  ### QUICKSTART
  # Prerequisites:
  # - Don't have any apps installed already which will be installed by casks
  # - must be on macos
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
  # \. ~/.zshrc
  # brew install --cask --adopt nsheaps/devsetup/nsheaps-base

  # cat << 'EOF' >> ~/.zshrc

  # setopt interactivecomments

  # source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh

  # # Initialize antidote's dynamic mode, which changes `antidote bundle`
  # # from static mode.
  # source <(antidote init)

  # antidote bundle <<EOBUNDLES
  #     zsh-users/zsh-autosuggestions
  #     zsh-users/zsh-completions
  #     getantidote/use-omz
  #     ohmyzsh/ohmyzsh path:lib
  #     ohmyzsh/ohmyzsh path:plugins/git
  #     ohmyzsh/ohmyzsh path:plugins/autojump
  #     ohmyzsh/ohmyzsh path:plugins/brew
  #     ohmyzsh/ohmyzsh path:plugins/direnv
  #     ohmyzsh/ohmyzsh path:plugins/docker
  #     ohmyzsh/ohmyzsh path:plugins/mise
  #     ohmyzsh/ohmyzsh path:plugins/thefuck
  #     ohmyzsh/ohmyzsh path:plugins/command-not-found
  #     ohmyzsh/ohmyzsh path:themes/robbyrussell.zsh-theme
  # EOBUNDLES

  # EOF

  # \. ~/.zshrc

  # mise use -g \
  #   node@lts \
  #   bun \
  #   python \
  #   golang
  # mise ls

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
  depends_on formula: 'shellcheck' # todo: get from mise?
  depends_on formula: 'shfmt' # todo: get from mise?
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
  depends_on cask: 'claude' # claude desktop
  depends_on cask: 'claude-code'
  depends_on cask: 'visual-studio-code'
  depends_on cask: 'google-chrome'
  depends_on cask: 'karabiner-elements' # keyboard customizer
  depends_on cask: 'slack'
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
    # TODO: make install/uninstall manage this
    <<~CAVEATS
      # Run the following to add the needed lines to your ~/.zshrc:

      ### COPY FROM HERE

      cat << 'EOF' >> ~/.zshrc

      setopt interactivecomments

      source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh

      # Initialize antidote's dynamic mode, which changes `antidote bundle`
      # from static mode.
      source <(antidote init)

      antidote bundle <<EOBUNDLES
          zsh-users/zsh-autosuggestions
          zsh-users/zsh-completions
          getantidote/use-omz
          ohmyzsh/ohmyzsh path:lib
          ohmyzsh/ohmyzsh path:plugins/git
          ohmyzsh/ohmyzsh path:plugins/autojump
          ohmyzsh/ohmyzsh path:plugins/brew
          ohmyzsh/ohmyzsh path:plugins/direnv
          ohmyzsh/ohmyzsh path:plugins/docker
          ohmyzsh/ohmyzsh path:plugins/mise
          ohmyzsh/ohmyzsh path:plugins/thefuck
          ohmyzsh/ohmyzsh path:plugins/command-not-found
          ohmyzsh/ohmyzsh path:themes/robbyrussell.zsh-theme
      EOBUNDLES

      EOF

      # re-source the rc file to load the plugins
      . ~/.zshrc

      gum spin --show-output --title "installing node@lts using mise" -- mise use -g node@lts
      gum spin --show-output --title "installing bun using mise"      -- mise use -g bun
      gum spin --show-output --title "installing python using mise".  -- mise use -g python
      gum spin --show-output --title "installing golang using mise"   -- mise use -g golang
      gum style '$ mise ls' '' "$(mise ls)"

      # install rosetta compatibility layer
      gum spin --show-output --title "installing rosetta compatibility layer" -- softwareupdate --install-rosetta

      # login to `gh`
      gum spin --show-output --title "logging into github using gh" -- true
      gh auth login

      # set up git to use `gh` as the credential helper
      gum spin --show-output --title "setting gh as git credential helper" -- gh setup-git

      gum style \
        'Setup is mostly complete. Please do the following:' \
        '  - restart your computer so the rc file gets sourced at the OS level on login' \
        '  - generate gpg keys and add to github and 1password' \
        '  - generate ssh keys and add to github and 1password' \

      ### END COPY HERE
    CAVEATS
  end
end
