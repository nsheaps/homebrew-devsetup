cask "nsheaps-base" do
  name 'nsheaps-base'
  desc 'A metaformula for installing the base applications for Nathan Heaps < nsheaps[at]gmail[dot]com >'
  homepage 'http://github.com/nsheaps/homebrew-devsetup'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  sha256 "b14702dd54ea5c48d2ebeb6425015c14794159a6b9d342178c81d2f2e79ed2db"
  version '1.0.3' # bump me if you want people to re-install these things, like if the list changed.

  stage_only true

  depends_on formula: "autojump"
  depends_on formula: "antigen"
  depends_on formula: "awscli"
  depends_on formula: "bash"
  depends_on formula: "ca-certificates"
  depends_on formula: "curl"
  depends_on formula: "coreutils"
  depends_on formula: "direnv"
  depends_on formula: "gh"
  depends_on formula: "git"
  depends_on formula: "gnupg"
  depends_on formula: "helm"
  depends_on formula: "kubectl"
  depends_on formula: "mise"
  depends_on formula: "openssl@3"
  depends_on formula: "pstree"
  depends_on formula: "shellcheck"
  depends_on formula: "shfmt"
  depends_on formula: "tmux"
  depends_on formula: "tilt"
  depends_on formula: "wget"
  # depends_on formula: "zsh" # TODO: only on linux

  depends_on cask: "loop"
  depends_on cask: "claude"
  depends_on cask: "claude-code"
  depends_on cask: "visual-studio-code"
  depends_on cask: "slack"
  depends_on cask: "notion"
  depends_on cask: "linear-linear"
  depends_on cask: "jordanbaird-ice"
  depends_on cask: "iterm2"
  depends_on cask: "itermai"
  depends_on cask: "itermbrowserplugin"
  depends_on cask: "zoom"
  depends_on cask: "spotify"
  depends_on cask: "1password"
  depends_on cask: "1password-cli"

  def install
    # even though there's stuff in the brew-meta-formula, brew needs something to install or it will
    # complain about an empty installation
    system "touch", "trick-brew-to-install-meta-formula"
    prefix.install "trick-brew-to-install-meta-formula"
  end


  def caveats
    # TODO: make install/uninstall manage this
    <<~CAVEATS
      # Run the following to add the needed lines to your ~/.zshrc:
      cat << EOF >> ~/.zshrc

      ANTIGEN_LOG="$HOME/.antigen/log.log"
      source $(brew --prefix)/share/antigen/antigen.zsh

      antigen use oh-my-zsh

      antigen bundles <<EOBUNDLES
          getantidote/use-omz@main
          git
          autojump
          brew
          direnv
          docker
          mise
          command-not-found
          zsh-users/zsh-syntax-highlighting
          zsh-users/zsh-autosuggestions
      EOBUNDLES
      antigen theme robbyrussell
      antigen apply

      # Then re-source the rc file to load all of the bundles
      \. ~/.zshrc
      ####### STOP SELECTING HERE #######
      EOF
    CAVEATS
  end
end
