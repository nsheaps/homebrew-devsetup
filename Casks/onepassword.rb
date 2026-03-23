cask 'onepassword' do
  name '1Password'
  desc '1Password desktop application and CLI'
  homepage 'https://1password.com'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  sha256 'b14702dd54ea5c48d2ebeb6425015c14794159a6b9d342178c81d2f2e79ed2db'
  version '1.0.0'

  depends_on cask: '1password'
  depends_on cask: '1password-cli'

  # stage_only true

  def install
    system 'touch', 'trick-brew-to-install-meta-formula'
    prefix.install 'trick-brew-to-install-meta-formula'
  end
end
