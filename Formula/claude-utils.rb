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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.332/claude-utils-darwin-arm64.tar.gz'
      sha256 '91c055bb60370acdc68d2aa26015cd7d96a191ec03f8859683082754afca20cc'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.332/claude-utils-darwin-amd64.tar.gz'
      sha256 '27b618a0af4b5ca7938ddd2347c05a3858fcb074e9f56528483bb0ccf9ee4c26'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.332/claude-utils-linux-arm64.tar.gz'
      sha256 '4574f259d43c099190a8c97f9583666ca24e2b7070ce6239abf827833d1f3fed'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.332/claude-utils-linux-amd64.tar.gz'
      sha256 'd7de7b4a75585077718476425a6c51cc8804df79464349adf6027396244be275'
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
