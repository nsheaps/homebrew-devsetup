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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.320/claude-utils-darwin-arm64.tar.gz'
      sha256 '27a6cbb44413f7a3b5a4c61e3b260b7f6354707f7b31b3da40f3804f961e1240'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.320/claude-utils-darwin-amd64.tar.gz'
      sha256 '79cf0671c5d8f3fbd41fa58d7e0bec947910839125a4bc8c061ba6b88cddf4fa'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.320/claude-utils-linux-arm64.tar.gz'
      sha256 'cb3837d1e55af461f886c8416139c75146b71270aa47774c845c1fdb335a4755'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.320/claude-utils-linux-amd64.tar.gz'
      sha256 'd2965592c7e290ac43d8bda40e3ed571bfc072c8840056f5c665a3699948f675'
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
