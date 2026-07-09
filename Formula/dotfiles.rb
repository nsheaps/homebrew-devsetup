# typed: false
# frozen_string_literal: true

# NOTE: url/sha256 below are placeholders for the initial v0.1.0 and are
# overwritten automatically by the dotfiles release pipeline (which renders
# Formula/dotfiles.rb from Formula/dotfiles.rb.gotmpl on each release). Until
# the first release lands, install with `brew install --HEAD nsheaps/devsetup/dotfiles`.
class Dotfiles < Formula
  desc 'Personal dotfiles: shell config plus the `dotfiles` wiring CLI'
  homepage 'https://github.com/nsheaps/dotfiles'
  url 'https://github.com/nsheaps/dotfiles/archive/refs/tags/v0.1.0.tar.gz'
  sha256 '0000000000000000000000000000000000000000000000000000000000000000'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/dotfiles.git', branch: 'main'
  end

  depends_on 'antidote'
  depends_on 'direnv'
  depends_on 'mise'

  def install
    # Bundle the whole repo so `dotfiles wire` can symlink _home/ and templates/
    # out of a version-stable location instead of a separate clone.
    libexec.install 'bin', '_home', 'templates'

    # Install a thin wrapper on PATH. It points DOTFILES_DIR at the version-
    # stable opt path (so managed sections written into ~/.zshrc survive
    # `brew upgrade`) and execs the real CLI. Inside a checkout of the repo,
    # direnv shadows this wrapper with the repo's own bin/dotfiles.
    (bin / 'dotfiles').write <<~SH
      #!/bin/bash
      export DOTFILES_DIR="${DOTFILES_DIR:-#{opt_libexec}}"
      exec "#{opt_libexec}/bin/dotfiles" "$@"
    SH
  end

  def post_install
    # Convenience: wire the dotfiles into $HOME on install so there is no manual
    # setup after `brew install`. `ensure-wired` runs non-interactively, only
    # wires when not already wired, and never fails the install. Opt out with
    # DOTFILES_SKIP_AUTOWIRE=1 (e.g. in CI).
    system bin / 'dotfiles', 'ensure-wired'
  end

  def caveats
    <<~CAVEATS
      dotfiles installs a global `dotfiles` command and, on install, wires your
      shell config into $HOME automatically.

      Re-deploy manually:      dotfiles wire
      Check if wired:          dotfiles check

      Open a new terminal (or `source ~/.zshrc`) to pick up the changes.

      Remaining manual steps (not handled automatically):
        - softwareupdate --install-rosetta --agree-to-license
        - gh auth login && gh auth setup-git
        - generate gpg/ssh keys and add them to GitHub / 1Password
        - restart so login shells re-source at the OS level
    CAVEATS
  end

  test do
    assert_match 'dotfiles', shell_output("#{bin}/dotfiles --version")
    assert_match 'wire', shell_output("#{bin}/dotfiles --help")
  end
end
