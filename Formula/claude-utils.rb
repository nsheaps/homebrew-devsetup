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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.247/claude-utils-darwin-arm64.tar.gz'
      sha256 'd3285ad38fbec8e1d601f4c143fd2cf8f913a4fd8bc797e361ab5982f8fdf5d0'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.247/claude-utils-darwin-amd64.tar.gz'
      sha256 '99f41a9d114b15ad2089c4f8b4876b1fb79c01da3b1ecfbd84228d3f51b5be57'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.247/claude-utils-linux-arm64.tar.gz'
      sha256 '8e689342fdb2b54fa38a188bc8c50096ad4006b952727478a6e93e53be5d7212'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.247/claude-utils-linux-amd64.tar.gz'
      sha256 '2534b2666104ff25655f521a18c87f4ebb210f193fe33db0a5ac9810b003ec40'
    end
  end

  depends_on 'fzf'
  depends_on 'gum'

  def install
    bin.install Dir['bin/*']
  end

  test do
    assert_match 'ccresume', shell_output("#{bin}/ccresume --help 2>&1", 1)
    assert_match 'Usage: agent-plugin', shell_output("#{bin}/agent-plugin --help")
    assert_match 'Usage: agent-hook', shell_output("#{bin}/agent-hook --help")
  end
end
