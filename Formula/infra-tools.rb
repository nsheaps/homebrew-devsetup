class InfraTools < Formula
  desc 'A metaformula for installing infrastructure related tooling'
  homepage 'http://github.com/nsheaps/homebrew-devsetup'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  sha256 'b14702dd54ea5c48d2ebeb6425015c14794159a6b9d342178c81d2f2e79ed2db'
  version '1.0.2' # bump me if you want people to re-install these things, like if the list changed.

  livecheck do
    skip 'Meta formulas cannot be updated'
  end

  # if these are installed from this tap, then devsetup upgrade-all will upgrade
  # them, otherwise the dependencies will only get upgraded if this formula changes.

  # if you want to reference another formula in another tap here so that it _will_ get
  # upgraded, use `devsetup alias <formula>`, then reference it with nsheaps/devsetup/<original>
  depends_on 'tfenv' # instead of terraform
  # depends_on "tgenv" # instead of terragrunt
  depends_on 'kubectl'
  depends_on 'k2tf'
  depends_on 'helm'
  depends_on 'awscli'
  depends_on 'openssl@3'
  depends_on 'ca-certificates'

  depends_on 'gh'
  depends_on 'doppler'

  def install
    # even though there's stuff in the brew-meta-formula, brew needs something to install or it will
    # complain about an empty installation
    system 'touch', 'trick-brew-to-install-meta-formula'
    prefix.install 'trick-brew-to-install-meta-formula'
  end
end
