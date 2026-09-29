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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.317/claude-utils-darwin-arm64.tar.gz'
      sha256 '7a285891f8d487a06fe95553bac1730abcb33b8a578ee951c081903a59888e0b'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.317/claude-utils-darwin-amd64.tar.gz'
      sha256 '17fc4edd98f80ae293a0a0f56b5b9e9757be9705ac06b179531004ef0feaa9db'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.317/claude-utils-linux-arm64.tar.gz'
      sha256 'ceca1284e22cec7ca64760750e64c6322ce66941134f5a3229c5e5cb03777835'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.317/claude-utils-linux-amd64.tar.gz'
      sha256 '4b3db780c6714246d2105bfbd0f2dcb37bb8bef7426d3104192c0f973211dcc9'
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
