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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.254/claude-utils-darwin-arm64.tar.gz'
      sha256 '1fb3c63355ec34cd2229d15c2f47aea363b27c9b072b36dcd65f493cafb11d06'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.254/claude-utils-darwin-amd64.tar.gz'
      sha256 '5c73e1ea914db5c204bd29bd10ccb9088bbbb208a9cda9d3009772bedc2d47f1'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.254/claude-utils-linux-arm64.tar.gz'
      sha256 'ac6190cfe84eb91bd0788126985c6d043d0b683be8390f20aae33553c1d64314'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.254/claude-utils-linux-amd64.tar.gz'
      sha256 'd1bbb24163afafd10010834af6664237ee382965121e93b1c49920e803b09bf4'
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
