# typed: false
# frozen_string_literal: true

class ClaudeUtils < Formula
  desc 'CLI utilities for Claude Code workflow management'
  homepage 'https://github.com/nsheaps/claude-utils'
  license 'MIT'

  # agent-plugin and agent-hook are native, self-contained binaries produced by
  # `bun build --compile` and shipped per-platform in the release tarballs. Everything
  # else in bin/ is platform-independent bash. No node/bun is needed at runtime.
  on_macos do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.270/claude-utils-darwin-arm64.tar.gz'
      sha256 'f00d1636915771dc20212da00a3eb7e4ae044b43ef84afbf1a32ed245d3c9b77'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.270/claude-utils-darwin-amd64.tar.gz'
      sha256 '9e3ebf7ebd0912bdb64b796139795d112d46e0b8802f19359f3f727b68db38e6'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.270/claude-utils-linux-arm64.tar.gz'
      sha256 '0206fd43a178d0139adb241d3b5e846451ac446faa83b5ff4da597f506731d3e'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.270/claude-utils-linux-amd64.tar.gz'
      sha256 'a1c001c806a5f3cee820fed5610187737779c67c02f73127eccba87b2b06501c'
    end
  end

  depends_on 'fzf'
  depends_on 'gum'

  def install
    # The release tarball wraps its payload in a single top-level dist/ directory. Homebrew strips
    # that lone leading directory and chdir's into it, so by the time this runs the working
    # directory is dist/. Install only dist/bin/ into #{bin} (lib/ lands at #{bin}/lib, where the
    # bash CLIs source it via $SCRIPT_DIR). Wrapping in dist/ means future non-bin payloads can be
    # shipped under dist/ (e.g. dist/share, dist/man) without being swept into #{bin}.
    bin.install Dir['bin/*']
  end

  test do
    assert_match 'ccresume', shell_output("#{bin}/ccresume --help 2>&1", 1)
    assert_match 'Usage: agent-plugin', shell_output("#{bin}/agent-plugin --help")
    assert_match 'Usage: agent-hook', shell_output("#{bin}/agent-hook --help")
  end
end
