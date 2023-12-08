# renovate: datasource=custom.ghfile registryUrl=Homebrew/homebrew-core depName=Formula/p/python@3.11.rb currentDigest=master
class PythonAT311 < formula
  desc 'Installs Python 3.11.x'
  homepage 'http://github.com/nsheaps/homebrew-devsetup'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  sha256 "b14702dd54ea5c48d2ebeb6425015c14794159a6b9d342178c81d2f2e79ed2db"
  version '1.0.0' # bump me if you want people to re-install these things, like if the list changed.

  livecheck do
    skip "Meta formulas cannot be updated"
  end

  # renovate:
  depends_on "https://raw.githubusercontent.com/Homebrew/homebrew-core/cca86c9c20f43a6e6f98b41e8988088188907c41/Formula/p/python@3.11.rb"

  def install
    # even though there's stuff in the brew-meta-formula, brew needs something to install or it will
    # complain about an empty installation
    system "touch", "trick-brew-to-install-meta-formula"
    prefix.install "trick-brew-to-install-meta-formula"
  end
end
