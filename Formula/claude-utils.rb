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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.294/claude-utils-darwin-arm64.tar.gz'
      sha256 '58c474a09e4ff327235f2427c8f474e90f11967825075fdb9169e0481b76d25a'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.294/claude-utils-darwin-amd64.tar.gz'
      sha256 '71bcc747594f512c888e71d8716b86110fb99a5587146e17c2be3009992df565'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.294/claude-utils-linux-arm64.tar.gz'
      sha256 '5f778ac93a5354506cbc2d80876a9a6fa1bb7ffaeff06529cad3b660ef197869'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.294/claude-utils-linux-amd64.tar.gz'
      sha256 'c93a651f5421eeb84879813df9edbb39cf091482068563be303fd32f43d6d17d'
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
