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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.321/claude-utils-darwin-arm64.tar.gz'
      sha256 '935fc125b23ddf3f088bd34ea2c4ff414859b783f1d3b7d88fe20ad2c5ce195f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.321/claude-utils-darwin-amd64.tar.gz'
      sha256 '347b23319adb1850cbd8594ba1593fde213c347966532281052280d4836115b6'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.321/claude-utils-linux-arm64.tar.gz'
      sha256 'a68e37e0f33f3c66c875601ed92dd5b43593d86502e473a74cbd41f0af82618a'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.321/claude-utils-linux-amd64.tar.gz'
      sha256 '2a34b5c2090a91a96e91221e2018892e7fe89ce0a32cfe462704346edee45382'
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
