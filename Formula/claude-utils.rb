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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.366/claude-utils-darwin-arm64.tar.gz'
      sha256 '97725a3c44ca82616f90b64cdc02e8a4c9227780b71ac1c5e825f9a966e7b4fc'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.366/claude-utils-darwin-amd64.tar.gz'
      sha256 '6fbeefff26256475c5a91187ea52abab94f94a2b11269802588e715179de5db4'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.366/claude-utils-linux-arm64.tar.gz'
      sha256 '38486a0f952f0cf9e6a89efafd0f9eaf160978aeb8964f0bcc47d8acda29066a'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.366/claude-utils-linux-amd64.tar.gz'
      sha256 'e72f4f5cdc5a313ee3235e06ef5e56e0bb47b1661f8119d8b41f188c196904a3'
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
