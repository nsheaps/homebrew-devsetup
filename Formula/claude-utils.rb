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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.316/claude-utils-darwin-arm64.tar.gz'
      sha256 '1d00057701cf6b187238c1834fbb3938f8711126f85b73d0cc52a25ea9ce8209'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.316/claude-utils-darwin-amd64.tar.gz'
      sha256 '6cc13e17536e57f0c8ab9243decb81eb151ddfc1d2f7299393300a26952fd589'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.316/claude-utils-linux-arm64.tar.gz'
      sha256 '28df3abc0b7e2fbe22e44a757f6e1c007fd7d4638e4fd45b1c402a51731a7021'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.316/claude-utils-linux-amd64.tar.gz'
      sha256 '78515023636162235b9d2d950cfe12b11936c83544f8bcf1086118660a0fffc2'
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
