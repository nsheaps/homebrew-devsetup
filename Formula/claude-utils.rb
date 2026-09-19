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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.306/claude-utils-darwin-arm64.tar.gz'
      sha256 'cf12cd8cbedee08d6cb9d35079ae2723b3014a869734effcc93ba3c93f99705e'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.306/claude-utils-darwin-amd64.tar.gz'
      sha256 'a3c9a8d17ea6d41b58fce436d52d32a431899eb9f537d108d0cdf59d507dc510'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.306/claude-utils-linux-arm64.tar.gz'
      sha256 'd1ffbcd583a56b579a205493fb3233d80e8059732ff11b1a0b2ad36d6cb3775c'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.306/claude-utils-linux-amd64.tar.gz'
      sha256 '9571f8fa7515992b9d0755efc0b3dbabee5f8810e5ec1e0bcb5e5b75f5edede9'
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
