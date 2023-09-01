class DevsetupBase < Formula
  desc 'A tool to setup a new development environment'
  homepage 'http://github.com/nsheaps/homebrew-devsetup'
  url 'https://raw.githubusercontent.com/nsheaps/homebrew-devsetup/main/Formula/devsetup-base.rb'
  version '0.0.1' # bump me if you want people to re-install these things, like if the list changed.
  sha256 "18178d02a85eec00bf87b5328dbc20582a4c07b414669687b18a4997e6786b37"

  livecheck do
    url :stable
  end

  # if these are installed from this tap, then devsetup upgrade-all will upgrade them
  # if you want to reference another formula in another tap here so that it _will_ get upgraded, use
  #   devsetup alias <formula>
  # depends_on "git"
  # depends_on "python3"
  # depends_on "ansible"

  # depends_on "nsheaps/devsetup/devsetup-bin"

  def install
    run 'echo', 'installllllio'
    system 'echo', 'install'
  end

  def uninstall
    super
    echo 'goodbye cruel world'
  end
end
