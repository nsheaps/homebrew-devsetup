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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.336/claude-utils-darwin-arm64.tar.gz'
      sha256 '5a7f2ee7f7ed473b629e01a9c1bce8d2ce115ade8636aa5c9b489b5002bdf3c2'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.336/claude-utils-darwin-amd64.tar.gz'
      sha256 '1bbf50b05b0cb41f917b98f008079169938dc446f1a6c60dc82a154b9fbb3be4'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.336/claude-utils-linux-arm64.tar.gz'
      sha256 '130b07497f201e066c0cd71cbf024413481e6bfea5bf3088f9b7c51bc852086c'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.336/claude-utils-linux-amd64.tar.gz'
      sha256 '7ae22acdcc44f9918968133651663b474c2370dcd5c3d6952ae70e950dba327a'
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
