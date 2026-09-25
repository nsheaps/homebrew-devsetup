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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.312/claude-utils-darwin-arm64.tar.gz'
      sha256 '8473243b630c9e0d83c2f63508fdc499b8567d60037224acb2611533db3f1e5c'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.312/claude-utils-darwin-amd64.tar.gz'
      sha256 '997ce2fb3635239448f48a2c0097f5d6075841f7a011fdfe041e4ae27a86751b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.312/claude-utils-linux-arm64.tar.gz'
      sha256 'd3435136a9d5d13597d7f0cae9dc342c981f8c4fdabe730c3d4976852b0c345f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.312/claude-utils-linux-amd64.tar.gz'
      sha256 'd816a65c8ca7f4e8e2f0af7cd3dc2555315ca9d7ea86957b569715d478367663'
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
