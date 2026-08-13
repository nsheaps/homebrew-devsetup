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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.262/claude-utils-darwin-arm64.tar.gz'
      sha256 'e7a0eccda94e3c024bec4149c89b2847d05cbe077cfe0dc61f2438474b5f9a92'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.262/claude-utils-darwin-amd64.tar.gz'
      sha256 'bbb023a82d1b866cf7a851cd016abfccd08155dcdfbc1f3d1aca488cf7fcc08a'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.262/claude-utils-linux-arm64.tar.gz'
      sha256 '1c3eca4dc48b80ecb967f25f8e8b7fe3380eb97a96c2cac15df7caa254168ee1'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.262/claude-utils-linux-amd64.tar.gz'
      sha256 'a7886a78f883ed6e43a005a7e084f19c0cd1fd82ea7b080c82f9aaa1c0e40043'
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
