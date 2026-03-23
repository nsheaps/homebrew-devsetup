class Onepassword < Formula
  desc '1Password - password manager desktop application'
  homepage 'https://1password.com'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  sha256 'b14702dd54ea5c48d2ebeb6425015c14794159a6b9d342178c81d2f2e79ed2db'
  version '1.0.0'
  license :cannot_represent

  livecheck do
    skip 'Upstream package manager handles updates (brew cask on macOS, apt on Linux)'
  end

  depends_on 'nsheaps/devsetup/onepassword-cli'

  def install
    system 'touch', 'trick-brew-to-install-meta-formula'
    prefix.install 'trick-brew-to-install-meta-formula'
  end

  def post_install
    if OS.mac?
      unless system(HOMEBREW_BREW_FILE, 'list', '--cask', '1password', err: :close, out: :close)
        system HOMEBREW_BREW_FILE, 'install', '--cask', '1password'
      end
    elsif OS.linux?
      # APT repo is already set up by the onepassword-cli dependency
      system 'sudo', 'apt-get', 'update',
        '-o', 'Dir::Etc::sourcelist=sources.list.d/1password.list',
        '-o', 'Dir::Etc::sourceparts=-',
        '-o', 'APT::Get::List-Cleanup=0'
      system 'sudo', 'apt-get', 'install', '-y', '1password'
    end
  end

  def caveats
    if OS.mac?
      <<~EOS
        1Password has been installed as a Homebrew cask.
        Update with: brew upgrade --cask 1password
      EOS
    else
      <<~EOS
        1Password has been installed via the official 1Password APT repository.
        Update with: sudo apt-get update && sudo apt-get upgrade 1password
      EOS
    end
  end
end
