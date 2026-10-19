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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.346/claude-utils-darwin-arm64.tar.gz'
      sha256 'ccfa356ba0fba67c6fd07b7cce9d2169d47b93dd5f1cc4ee1cc55025a1712f87'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.346/claude-utils-darwin-amd64.tar.gz'
      sha256 'd1168434c47a35a893cbf23ce80125196fa3356d6e5572fc8567d9d5938919eb'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.346/claude-utils-linux-arm64.tar.gz'
      sha256 'c0ff12034c90398e6657bfcd56bc47a5f50ec97918bfcfa2fe7c2c2252ec2a45'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.346/claude-utils-linux-amd64.tar.gz'
      sha256 '4b007757a39fdbdaf7490e9dba3b3426d0ee3a3db93f9a75c511c8092ddce425'
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
