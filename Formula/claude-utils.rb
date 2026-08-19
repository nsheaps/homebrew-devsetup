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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.271/claude-utils-darwin-arm64.tar.gz'
      sha256 '9c828176cf91804dc096e6d9fb1659696bc0020151bf55d94c822e5e56583925'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.271/claude-utils-darwin-amd64.tar.gz'
      sha256 '26719ab3146924b70b350700e618f0f13af0ea8f6a6e81c0b38250e938d3d3a6'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.271/claude-utils-linux-arm64.tar.gz'
      sha256 'faf5b663c9f5e1ce6414a9e00ac1b7631950fbe1645df8ff83c20fc15e75b935'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.271/claude-utils-linux-amd64.tar.gz'
      sha256 'd2035631131de172a0a1be8b788a86da4bc4bba396bdd7068adf393d22152117'
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
