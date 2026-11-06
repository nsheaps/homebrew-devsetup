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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.368/claude-utils-darwin-arm64.tar.gz'
      sha256 'dcaf7da1de94c8856124e5bb8966cc4edfd6588af66429fc804a587902aca7a2'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.368/claude-utils-darwin-amd64.tar.gz'
      sha256 'edf4d2d06c585d7f4d3174b78efd9cdf2a2cf76ae0881573f223104ddb3a9eeb'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.368/claude-utils-linux-arm64.tar.gz'
      sha256 'c2c473a13e198d7224c1041c330c511cef437b4e9d0182bc46934b0df78018f6'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.368/claude-utils-linux-amd64.tar.gz'
      sha256 'c98562cd58db65c6859bc4928842e989f69db03bd95f7de529279f38d7fe2c28'
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
