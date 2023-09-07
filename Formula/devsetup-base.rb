class DevsetupBase < Formula
  desc 'A tool to setup a new development environment'
  homepage 'http://github.com/nsheaps/homebrew-devsetup'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  version '0.0.1' # bump me if you want people to re-install these things, like if the list changed.

  # if these are installed from this tap, then devsetup upgrade-all will upgrade them
  # if you want to reference another formula in another tap here so that it _will_ get upgraded, use
  #   devsetup alias <formula>
  depends_on "git"
  # depends_on "python3"
  # depends_on "ansible"

  # depends_on "nsheaps/devsetup/devsetup-bin"

  def install
    puts 'install'

  end

  def uninstall
    super
    puts 'goodbye cruel world'
  end
end
