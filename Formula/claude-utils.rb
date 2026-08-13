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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.261/claude-utils-darwin-arm64.tar.gz'
      sha256 '03646072c40a572e4ebc7f0fa6d5830e8f912934d7941d21002aa6ac02aed2fb'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.261/claude-utils-darwin-amd64.tar.gz'
      sha256 '37ccc7165a323dc4e4750f8cbae66d12e75d2e988d2d196790b887caac56cd61'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.261/claude-utils-linux-arm64.tar.gz'
      sha256 '50f9ddc1371b17c2d8b421176d06fc69642f0605b15e36af9daf19f7a02fdb04'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.261/claude-utils-linux-amd64.tar.gz'
      sha256 'c5a69c4db861db52068df96fb742cd923a191122225b0f3eb7ff600119d2d869'
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
