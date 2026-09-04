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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.291/claude-utils-darwin-arm64.tar.gz'
      sha256 '70a8c25c4489fa8336d624929b7f486226ca9d4bbcbaad251505256b46e04690'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.291/claude-utils-darwin-amd64.tar.gz'
      sha256 'c65ded2a602be4855d8b193f73f67bf77afddaac87d91b0f957382cadfa30b31'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.291/claude-utils-linux-arm64.tar.gz'
      sha256 '5da77948a0fa023440b43d0d6888021d9651df817c5242483af818fc17fa36f8'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.291/claude-utils-linux-amd64.tar.gz'
      sha256 '944ae53af41e7a2e6cf28ae7449b2b5143b46c73b6163fdd2256d0b9b76f5fd7'
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
