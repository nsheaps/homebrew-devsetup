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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.315/claude-utils-darwin-arm64.tar.gz'
      sha256 '954efc34b2bb0a2a4d6b499d5e2e5542ef410f9024671fbea5baef41d2a40853'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.315/claude-utils-darwin-amd64.tar.gz'
      sha256 'a4ef8d09bcbbb821f6c463ee2bb6666149df78285c6f3176e47eefa5f6396db1'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.315/claude-utils-linux-arm64.tar.gz'
      sha256 'b2a80e5a774bb090aba54900132a641d3d60d6c2e1c6b13693bf7bfa68b09add'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.315/claude-utils-linux-amd64.tar.gz'
      sha256 '7df3e1ddd94cafbc9014b8fd6f608cf6d1dc6ef33653a33b8f19151b21b513c6'
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
