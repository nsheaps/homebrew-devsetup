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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.314/claude-utils-darwin-arm64.tar.gz'
      sha256 '06ea7adbd052f85c7f6d6545724229557c51a3bbdacdd5e832fce6e42f64ead1'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.314/claude-utils-darwin-amd64.tar.gz'
      sha256 'f1dadf1dc71dd88378ec5b0a0e175071f0b3e7202acefb4a60fb5f666db4d76f'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.314/claude-utils-linux-arm64.tar.gz'
      sha256 'a0346cbc1d26af5cb46fc09f4f05bee1ba68ca7df7380b9756081c66d23cefd1'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.314/claude-utils-linux-amd64.tar.gz'
      sha256 'cd9a33f8f2a46f19bd8868d371f411782f6c0e88ec52dab6ae9111340e06380a'
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
