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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.322/claude-utils-darwin-arm64.tar.gz'
      sha256 '64753c5439ebf0b31c232a11a1aaa6acba377432a508ee16f4c2c9c9ab5db332'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.322/claude-utils-darwin-amd64.tar.gz'
      sha256 '15817947cfcc435892a4ad6eef9f5acc982d6964a4217a8d56d26bcc54ef5fdc'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.322/claude-utils-linux-arm64.tar.gz'
      sha256 'c32da323d68d11987092d83436f611713f22d87d1838cebabd581536f8cefeba'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.322/claude-utils-linux-amd64.tar.gz'
      sha256 '9380c600b85fb2323b8f723691d46d6563fd28e62b41a26bfb31cc13d6811f83'
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
