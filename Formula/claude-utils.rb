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
      sha256 'cea4c0943aa1b2c3118786f0a5655d80675531d78f89bcb89b48b36f5f3db420'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.254/claude-utils-darwin-amd64.tar.gz'
      sha256 '240719bddc73581e390541c021a05febb5c19eb2f381c0c012a3b1628ad276b0'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.254/claude-utils-linux-arm64.tar.gz'
      sha256 '265e24b9dfbd5f4d05b4ca249a1799f9a6dddc4c2c672a3b7cad55eb68f5307f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.254/claude-utils-linux-amd64.tar.gz'
      sha256 '1200be05ad6330494d95090deb87eb5f8490f740bd4a38c2db72dd65bc570aa2'
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
