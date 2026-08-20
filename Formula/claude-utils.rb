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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.272/claude-utils-darwin-arm64.tar.gz'
      sha256 'a1fcbcd0e71f6516884a214827404e100249501666c85aa3b4dd78201b9629d6'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.272/claude-utils-darwin-amd64.tar.gz'
      sha256 '7d54d2877ef339ca694cdbf42f169141be9cf20d3d0b92a58a3621fb4aa3da27'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.272/claude-utils-linux-arm64.tar.gz'
      sha256 'a0066b94e30d428f9fca4942d7ba45bb6e90b3c5a54116ec62fb4fd58940ca14'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.272/claude-utils-linux-amd64.tar.gz'
      sha256 'd9cd75268cdf496af44f199169950d32665a5e4f14fcb7914c0c3303072c115e'
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
