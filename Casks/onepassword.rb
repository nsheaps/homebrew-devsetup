cask 'onepassword' do
  name '1Password'
  desc '1Password desktop application'
  homepage 'https://1password.com'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  sha256 'b14702dd54ea5c48d2ebeb6425015c14794159a6b9d342178c81d2f2e79ed2db'
  version '1.0.0'

  # macOS: 1Password recommends downloading from 1password.com, which is
  # exactly what the upstream Homebrew cask automates.
  on_macos do
    depends_on macos: '>= :monterey'
    depends_on cask: '1password'
  end

  # Linux: 1Password recommends installing via their APT repository.
  # The APT repo is set up by the onepassword-cli formula (shared repo),
  # so we depend on that and just install the desktop package.
  on_linux do
    depends_on formula: 'nsheaps/devsetup/onepassword-cli'

    postflight do
      system_command '/usr/bin/sudo',
        args: [
          'apt-get', 'update',
          '-o', 'Dir::Etc::sourcelist=sources.list.d/1password.list',
          '-o', 'Dir::Etc::sourceparts=-',
          '-o', 'APT::Get::List-Cleanup=0',
        ]
      system_command '/usr/bin/sudo',
        args: ['apt-get', 'install', '-y', '1password']
    end
  end

  def install
    system 'touch', 'trick-brew-to-install-meta-formula'
    prefix.install 'trick-brew-to-install-meta-formula'
  end

  def caveats
    if OS.mac?
      <<~EOS
        1Password has been installed via the upstream Homebrew cask.
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
