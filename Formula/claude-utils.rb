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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.265/claude-utils-darwin-arm64.tar.gz'
      sha256 '68075659b6f6475315fa89ebceb6ebb9e4199c276456407b090340b72866d037'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.265/claude-utils-darwin-amd64.tar.gz'
      sha256 '860571db9dddb6f63b7a1b0a8ee2f3f313a3f404f48b01a9a7ab2b98a6b651b7'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.265/claude-utils-linux-arm64.tar.gz'
      sha256 '7a9c67f87fec741d238d4f1493bde4c934c14a8a7fadaa5d29c5b8086a5cacde'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.265/claude-utils-linux-amd64.tar.gz'
      sha256 '2a24c55120e6f9d0c33df736b369558264b031659e72558eaa6f976262a4d64d'
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
