# typed: false
# frozen_string_literal: true

class Dotfiles < Formula
  desc 'Personal dotfiles: shell config plus the `dotfiles` wiring CLI'
  homepage 'https://github.com/nsheaps/dotfiles'
  url 'https://github.com/nsheaps/dotfiles/archive/refs/tags/v0.0.2.tar.gz'
  sha256 '1f1bef9de9a05d5f74442b43dd47428d68e213a6468256c17d3b63b3b2a4a12c'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/dotfiles.git', branch: 'main'
  end

  depends_on 'antidote'
  depends_on 'direnv'
  depends_on 'mise'

  def install
    # Bundle the whole repo so `dotfiles wire` can symlink internal/, _home/,
    # and templates/ out of a version-stable location instead of a separate clone.
    libexec.install 'bin', 'internal', '_home', 'templates'

    # Install a thin wrapper on PATH that just execs the real CLI at the
    # version-stable opt path. Deliberately does NOT export a DOTFILES_DIR
    # default here — bin/dotfiles' own resolve_dotfiles_dir() already falls
    # back to its own script location (this opt path) when nothing else
    # applies, and it also checks for a real git checkout at ~/.dotfiles
    # (from `wire --repo`) first. A hardcoded default here would win over
    # that ~/.dotfiles check every time (since it makes the env var look
    # "already set" to the exec'd script), silently defeating --repo on
    # every invocation after the first. Inside a checkout of the repo,
    # direnv exporting its own DOTFILES_DIR is still respected normally,
    # since child processes inherit an already-exported env var either way
    # — nothing extra needed here for that case either.
    #
    # DOTFILES_DEFAULT_REPO_URL is safe to export unconditionally, unlike
    # DOTFILES_DIR above: cmd_wire only consults it to pick a default `--repo`
    # target when none was passed explicitly, and nothing ever persists it
    # anywhere, so there's no "looks already set forever" trap. This is what
    # makes a brew-installed `dotfiles wire` (no flags) default to cloning
    # this same repo to ~/.dotfiles instead of just symlinking the bundled
    # libexec copy — someone wiring their OWN separate dotfiles repo instead
    # passes an explicit `--repo <their-url>`, which always wins.
    (bin / 'dotfiles').write <<~SH
      #!/bin/bash
      export DOTFILES_DEFAULT_REPO_URL="${DOTFILES_DEFAULT_REPO_URL:-#{homepage}.git}"
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
