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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.328/claude-utils-darwin-arm64.tar.gz'
      sha256 'b49155d49e5de75b94312b0b1df31d07fb235cf6cec0cf9b2e9642d25cfd9583'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.328/claude-utils-darwin-amd64.tar.gz'
      sha256 '17718911b9f3238832e9d96f5ee35c485692bc6b9fad56284e6e1214e7d88aa3'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.328/claude-utils-linux-arm64.tar.gz'
      sha256 '68e78451bc20d1cc6a3eb41d7b033f3a7b068ac4cc640bb62c77aec11efabed3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.328/claude-utils-linux-amd64.tar.gz'
      sha256 '9eb956767021f5124955b7afce6057d4c8968e18b991ff8a28625189b789c5ce'
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
