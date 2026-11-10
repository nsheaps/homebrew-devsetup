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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.373/claude-utils-darwin-arm64.tar.gz'
      sha256 'e06060a64a155cc44bf8462d1083f3b20b118b6f8477bda9811e1ca4b0f1c1ca'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.373/claude-utils-darwin-amd64.tar.gz'
      sha256 '541af9422f6176612d6e81e626ce4ccbcb522be2d2ed5123319cf62c87d47ed9'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.373/claude-utils-linux-arm64.tar.gz'
      sha256 '0f2ef4e8f2b70e075b6209cff11b27d036986dbf914ab3c5a299de3dc57403f0'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.373/claude-utils-linux-amd64.tar.gz'
      sha256 '50e808de65a55a3d0ac0133b754b693617daeea3354e7330f1ca4326324dc65e'
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
