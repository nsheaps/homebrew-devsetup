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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.284/claude-utils-darwin-arm64.tar.gz'
      sha256 '05e2309e1e48e1e0b868f82925baa5937fec09c12a325b028122f4eb2d231fc7'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.284/claude-utils-darwin-amd64.tar.gz'
      sha256 '06e3f15a8d1ed9c4813650ddef5481e7335c70d24db2f5275e2c12e23771fb56'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.284/claude-utils-linux-arm64.tar.gz'
      sha256 'f185d42ccb923a93febc618be9d3392afb6661181e49082f6ed59936edee7927'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.284/claude-utils-linux-amd64.tar.gz'
      sha256 '5b63d90c65fa2e4615cde6377ee5e2cb13024d350c1511d489c8b9404b3ea276'
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
