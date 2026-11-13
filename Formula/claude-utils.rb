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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.378/claude-utils-darwin-arm64.tar.gz'
      sha256 '3f55109a458f547b36eb16c0a77ea51fe3f10ea1b93563a4f89c1d41254341b3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.378/claude-utils-darwin-amd64.tar.gz'
      sha256 '660ba15c4bbade047c2b8e9e5895c9ab7c2cdd906142914bbe9a42c6dd26864b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.378/claude-utils-linux-arm64.tar.gz'
      sha256 '0c4891519ae2e492da898b2c5c5ee913fa30184087764825b4478decb288408e'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.378/claude-utils-linux-amd64.tar.gz'
      sha256 '38964837802f3c641f23521ba5ebe4380dbc0b4a73db111040b1c1734a1df049'
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
