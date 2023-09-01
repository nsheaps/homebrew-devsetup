class DevsetupBase < Formula
  desc 'A tool to setup a new development environment'
  homepage 'http://github.com/nsheaps/homebrew-devsetup'

  # depends_on "git"
  # depends_on "python3"
  # depends_on "ansible"

  # depends_on "nsheaps/devsetup/devsetup-bin"

  def install
    system 'echo', 'install'
  end

  def uninstall
    super
    echo 'goodbye cruel world'
  end
end
