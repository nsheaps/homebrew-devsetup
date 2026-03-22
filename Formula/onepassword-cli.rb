class OnepasswordCli < Formula
  desc '1Password CLI - command-line access to 1Password'
  homepage 'https://developer.1password.com/docs/cli/'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  sha256 'b14702dd54ea5c48d2ebeb6425015c14794159a6b9d342178c81d2f2e79ed2db'
  version '1.0.0'
  license :cannot_represent

  livecheck do
    skip 'Upstream package manager handles updates (brew cask on macOS, apt on Linux)'
  end

  def install
    system 'touch', 'trick-brew-to-install-meta-formula'
    prefix.install 'trick-brew-to-install-meta-formula'
  end

  def post_install
    if OS.mac?
      unless system(HOMEBREW_BREW_FILE, 'list', '--cask', '1password-cli', err: :close, out: :close)
        system HOMEBREW_BREW_FILE, 'install', '--cask', '1password-cli'
      end
    elsif OS.linux?
      setup_apt_repo
      system 'sudo', 'apt-get', 'update', '-o', 'Dir::Etc::sourcelist=sources.list.d/1password.list',
             '-o', 'Dir::Etc::sourceparts=-', '-o', 'APT::Get::List-Cleanup=0'
      system 'sudo', 'apt-get', 'install', '-y', '1password-cli'
    end
  end

  def caveats
    if OS.mac?
      <<~EOS
        1Password CLI has been installed as a Homebrew cask.
        Update with: brew upgrade --cask 1password-cli
      EOS
    else
      <<~EOS
        1Password CLI has been installed via the official 1Password APT repository.
        Update with: sudo apt-get update && sudo apt-get upgrade 1password-cli
      EOS
    end
  end

  private

  def setup_apt_repo
    ohai 'Setting up 1Password APT repository...'

    arch = if Hardware::CPU.arm?
             'arm64'
           else
             'amd64'
           end

    # Add GPG key
    gpg_keyring = '/usr/share/keyrings/1password-archive-keyring.gpg'
    unless File.exist?(gpg_keyring)
      system 'bash', '-c',
             "curl -sS https://downloads.1password.com/linux/keys/1password.asc | " \
             "sudo gpg --dearmor --output #{gpg_keyring}"
    end

    # Add APT source
    sources_file = '/etc/apt/sources.list.d/1password.list'
    unless File.exist?(sources_file)
      system 'bash', '-c',
             "echo 'deb [arch=#{arch} signed-by=#{gpg_keyring}] " \
             "https://downloads.1password.com/linux/debian/#{arch} stable main' | " \
             "sudo tee #{sources_file}"
    end

    # Set up debsig-verify policy
    policy_dir = '/etc/debsig/policies/AC2D62742012EA22'
    keyring_dir = '/usr/share/debsig/keyrings/AC2D62742012EA22'

    unless File.exist?("#{policy_dir}/1password.pol")
      system 'sudo', 'mkdir', '-p', policy_dir
      system 'bash', '-c',
             'curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | ' \
             "sudo tee #{policy_dir}/1password.pol"
    end

    unless File.exist?("#{keyring_dir}/debsig.gpg")
      system 'sudo', 'mkdir', '-p', keyring_dir
      system 'bash', '-c',
             'curl -sS https://downloads.1password.com/linux/keys/1password.asc | ' \
             "sudo gpg --dearmor --output #{keyring_dir}/debsig.gpg"
    end
  end
end
