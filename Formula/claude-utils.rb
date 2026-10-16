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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.341/claude-utils-darwin-arm64.tar.gz'
      sha256 'c82c37a2984625b7c149bcc6318d32ceaf5428a505710dd44fea1ae407b88a26'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.341/claude-utils-darwin-amd64.tar.gz'
      sha256 'e2400d2ebe7f9bea946c6399badea51c1072517c998554fe816fb9f6f84ddd90'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.341/claude-utils-linux-arm64.tar.gz'
      sha256 '2599eceddf4fe643cc085e21748bf20bab640fd89a38f81c80e7aac1c29580d7'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.341/claude-utils-linux-amd64.tar.gz'
      sha256 'd0091175f09e6f69093a5db9f81a26cd3e21418d6d64551f9c7e45108f34cfd9'
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
