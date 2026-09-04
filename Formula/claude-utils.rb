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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.290/claude-utils-darwin-arm64.tar.gz'
      sha256 'bb91c36009abb08e539040dfb30c87ddd137fe881c938eb53a351fbe1f42abfc'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.290/claude-utils-darwin-amd64.tar.gz'
      sha256 'd9fcb58ef14339f3bfbd93311a8c57824d52dae7c4508f44518d3d51f92e503c'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.290/claude-utils-linux-arm64.tar.gz'
      sha256 '6d44c42cbe4074ca2c70e13cc6c1d05264791ed4b121dbc298e4846399b46c89'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.290/claude-utils-linux-amd64.tar.gz'
      sha256 '3a7953017b0752c83f0066bcde1493162af39758ac857fae8237ae63a3621c20'
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
