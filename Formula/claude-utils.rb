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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.313/claude-utils-darwin-arm64.tar.gz'
      sha256 '0dec573b5817a60c24cf713bdff71b7eedcf7e87b0589130381b415643e1cda5'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.313/claude-utils-darwin-amd64.tar.gz'
      sha256 '453bdf0500e40c7451f1a1081734c1f69148854f501bdd9ef8fccab12295db9a'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.313/claude-utils-linux-arm64.tar.gz'
      sha256 'b2414e45523d224d2fa68d1191abb69592d460c13aa75c76837226628effcf34'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.313/claude-utils-linux-amd64.tar.gz'
      sha256 '509a65d164c3a18ba7c7089357b2233221e8d9715999c564ee18c04644cf2a68'
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
