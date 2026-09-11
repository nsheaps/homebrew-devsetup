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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.300/claude-utils-darwin-arm64.tar.gz'
      sha256 '506df2fc25a5bcdce08b6f1da0ab492b071094b4024a50710bb00dc0e7fe042b'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.300/claude-utils-darwin-amd64.tar.gz'
      sha256 '836497c3cdcda864a8dcb5a567b126e673629cb1f4429b14ebf6fc9940c0470b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.300/claude-utils-linux-arm64.tar.gz'
      sha256 'deeab111ca12d9be172a681a81002cf72d69556df7265fe78ab65b5cab5ffa6e'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.300/claude-utils-linux-amd64.tar.gz'
      sha256 '23afcd4eca61967f21cd1eefb1464e3d9d46bf9edaf1a01368218ae6f66e5a2a'
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
