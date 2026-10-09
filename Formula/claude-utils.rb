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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.333/claude-utils-darwin-arm64.tar.gz'
      sha256 '8b80ba38e16e220f539fc7271c4cfe923ea2d6f1b695838cdf44cd9475d313dc'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.333/claude-utils-darwin-amd64.tar.gz'
      sha256 '8ee06ca7cee7fd0fb24a2991aba435e6656876dcc322132816881919fc6537d2'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.333/claude-utils-linux-arm64.tar.gz'
      sha256 '2e965698d3511d66bc6393b5c4f0bbf177935942cddebfcc7e2fc7d2eace2d16'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.333/claude-utils-linux-amd64.tar.gz'
      sha256 'cbfa3c2306343a6c7fea1c4945c4ac7d7b710da0ca57cbbba4867c944babec83'
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
