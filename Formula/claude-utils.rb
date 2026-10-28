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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.356/claude-utils-darwin-arm64.tar.gz'
      sha256 '215d528069a9002ff23249bf92f65171cbc9cfdeb3e73244a3194e18c9fafdf8'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.356/claude-utils-darwin-amd64.tar.gz'
      sha256 'd5a9b804d005f9dd42cab9552c3304db766dd3e15d27bced336f075bccc93b4f'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.356/claude-utils-linux-arm64.tar.gz'
      sha256 '5b1cb494a4f7e7bd147d0a80fc3ca722fcf5836763cfbbf12b7eb6b74de983e9'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.356/claude-utils-linux-amd64.tar.gz'
      sha256 'd767379907b3a70731691172885d8289ec081f88a2f729e026e8db5c9471c1f2'
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
