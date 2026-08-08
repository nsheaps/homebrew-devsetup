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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.251/claude-utils-darwin-arm64.tar.gz'
      sha256 '009909728cbf01c0d38e98a0d70e017e7be16d098fedc17aacd3974f4cbc17eb'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.251/claude-utils-darwin-amd64.tar.gz'
      sha256 'ef89b9aaf26487276b8a5930defe13b6f1e7f4f0aa8b8d12d43aeaa268412bcd'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.251/claude-utils-linux-arm64.tar.gz'
      sha256 'df9ca9bfa9f20a01e8bb43f4f438cf3e192c669151ba42fdfb638ebed2401527'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.251/claude-utils-linux-amd64.tar.gz'
      sha256 'ec45a0ca3b470d6d5bd4d13c0d2fc06eb22500b09aab8ffc42b4bb3918a0f5ae'
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
