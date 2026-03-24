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
      install_macos_cask
    elsif OS.linux?
      install_linux_apt
    end
  end

  def caveats
    if OS.mac?
      <<~CAVEAT
        1Password CLI has been installed as a Homebrew cask.
        Update with: brew upgrade --cask 1password-cli
      CAVEAT
    else
      <<~CAVEAT
        1Password CLI has been installed via the official 1Password APT repository.
        Update with: sudo apt-get update && sudo apt-get upgrade 1password-cli
      CAVEAT
    end
  end

  private

  def install_macos_cask
    return if system(HOMEBREW_BREW_FILE, 'list', '--cask', '1password-cli', err: :close, out: :close)

    system HOMEBREW_BREW_FILE, 'install', '--cask', '1password-cli'
  end

  def install_linux_apt
    setup_apt_repo
    apt_update_args = [
      'sudo', 'apt-get', 'update',
      '-o', 'Dir::Etc::sourcelist=sources.list.d/1password.list',
      '-o', 'Dir::Etc::sourceparts=-',
      '-o', 'APT::Get::List-Cleanup=0'
    ]
    system(*apt_update_args)
    system 'sudo', 'apt-get', 'install', '-y', '1password-cli'
  end

  def setup_apt_repo
    ohai 'Setting up 1Password APT repository...'
    arch = Hardware::CPU.arm? ? 'arm64' : 'amd64'
    install_apt_gpg_key
    install_apt_source(arch)
    install_debsig_policy
  end

  def install_apt_gpg_key
    gpg_keyring = '/usr/share/keyrings/1password-archive-keyring.gpg'
    return if File.exist?(gpg_keyring)

    gpg_cmd = 'curl -sS https://downloads.1password.com/linux/keys/1password.asc ' \
      "| sudo gpg --dearmor --output #{gpg_keyring}"
    system 'bash', '-c', gpg_cmd
  end

  def install_apt_source(arch)
    gpg_keyring = '/usr/share/keyrings/1password-archive-keyring.gpg'
    sources_file = '/etc/apt/sources.list.d/1password.list'
    return if File.exist?(sources_file)

    deb_line = "deb [arch=#{arch} signed-by=#{gpg_keyring}] " \
      "https://downloads.1password.com/linux/debian/#{arch} stable main"
    system 'bash', '-c', "echo '#{deb_line}' | sudo tee #{sources_file}"
  end

  def install_debsig_policy
    install_debsig_policy_file
    install_debsig_keyring
  end

  def install_debsig_policy_file
    policy_dir = '/etc/debsig/policies/AC2D62742012EA22'
    return if File.exist?("#{policy_dir}/1password.pol")

    system 'sudo', 'mkdir', '-p', policy_dir
    pol_cmd = 'curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol ' \
      "| sudo tee #{policy_dir}/1password.pol"
    system 'bash', '-c', pol_cmd
  end

  def install_debsig_keyring
    keyring_dir = '/usr/share/debsig/keyrings/AC2D62742012EA22'
    return if File.exist?("#{keyring_dir}/debsig.gpg")

    system 'sudo', 'mkdir', '-p', keyring_dir
    debsig_cmd = 'curl -sS https://downloads.1password.com/linux/keys/1password.asc ' \
      "| sudo gpg --dearmor --output #{keyring_dir}/debsig.gpg"
    system 'bash', '-c', debsig_cmd
  end
end
