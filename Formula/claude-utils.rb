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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.353/claude-utils-darwin-arm64.tar.gz'
      sha256 '9ddb11b7244eac880980bf18bf43ec3d772d7f27f58542b08670a68f84323ad4'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.353/claude-utils-darwin-amd64.tar.gz'
      sha256 '3b851b19ff5a9ed92c9e13dadcb37f923bfb4d71b2fad8acfd3b745890be75b0'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.353/claude-utils-linux-arm64.tar.gz'
      sha256 '507425716f417b536f19062ed657ed581b43a45f61e81af1d6134c699ed93ec3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.353/claude-utils-linux-amd64.tar.gz'
      sha256 'a1e17b1f455c9a5d875ae7b1311cb5026a188aff1864ac6ae68116ab3ec6a011'
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
