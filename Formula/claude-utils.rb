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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.390/claude-utils-darwin-arm64.tar.gz'
      sha256 '4d00363b0d8ca15be6211fb748e2ead120e46b74666af1db75183994c8fa8ba4'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.390/claude-utils-darwin-amd64.tar.gz'
      sha256 '2ce5e524d1094c76a2181e8c0b01783792a8ca799107c48a31785a0d30751273'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.390/claude-utils-linux-arm64.tar.gz'
      sha256 '9960cb1683942fb08fbe189bc8e1ab3b5a4eca10ce81b370b19d9ea753b3bdf0'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.390/claude-utils-linux-amd64.tar.gz'
      sha256 '178661b87b3b8f638f029e094a75e2c242f8d7e616bb43bad835c2668bf0f4dc'
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
