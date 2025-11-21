class NsheapsBase < Formula
  desc 'A metaformula for installing the base applications for Nathan Heaps < nsheaps[at]gmail[dot]com >'
  homepage 'http://github.com/nsheaps/homebrew-devsetup'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  sha256 "b14702dd54ea5c48d2ebeb6425015c14794159a6b9d342178c81d2f2e79ed2db"
  version '1.0.0' # bump me if you want people to re-install these things, like if the list changed.

  livecheck do
    skip "Meta formulas cannot be updated"
  end

  # if these are installed from this tap, then devsetup upgrade-all will upgrade
  # them, otherwise the dependencies will only get upgraded if this formula changes.
  tap nsheaps/devsetup

  depends_on "autojump"
  depends_on "antigen"
  depends_on "awscli"
  depends_on "bash"
  depends_on "ca-certificates"
  depends_on "direnv"
  depends_on "gh"
  depends_on "git"
  depends_on "helm"
  depends_on "kubectl"
  depends_on "mise"
  depends_on "openssl@3"

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
  depends_on cask: "1password"
  depends_on cask: "1password-cli"

  def install
    # even though there's stuff in the brew-meta-formula, brew needs something to install or it will
    # complain about an empty installation
    system "touch", "trick-brew-to-install-meta-formula"
    prefix.install "trick-brew-to-install-meta-formula"
  end


  def caveats
    <<~CAVEATS
      # Run the following to add the needed lines to your ~/.zshrc:
      cat << EOF >> ~/.zshrc

      source $(brew --prefix)/share/antigen/antigen.zsh

      antigen use oh-my-zsh
      antigen bundle git
      antigen bundle autojump
      antigen bundle brew
      antigen bundle direnv
      antigen bundle docker
      antigen bundle mise
      antigen bundle command-not-found
      antigen bundle zsh-users/zsh-syntax-highlighting
      antigen bundle zsh-users/zsh-autosuggestions
      antigen theme robbyrussell
      antigen apply

      # Then re-source the rc file to load all of the bundles
      \. ~/.zshrc
      ####### STOP SELECTING HERE #######
      EOF
    CAVEATS
  end
end
