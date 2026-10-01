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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.318/claude-utils-darwin-arm64.tar.gz'
      sha256 '9a42b8523f2fc5555f3dd71ed413a03b7d4d38c113d13b37b7c8167f1195c803'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.318/claude-utils-darwin-amd64.tar.gz'
      sha256 '0a6257cfef32bff60ebbb9e9b8c96d01d58e1807954300eed8c1a208c7debc69'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.318/claude-utils-linux-arm64.tar.gz'
      sha256 '7dcd59a1db88401f304a08b06da8292a6690ebaec6307cf5e9e5f51474b0a7e3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.318/claude-utils-linux-amd64.tar.gz'
      sha256 '21b4a7f04630dfeba6c0759ca866621716dcc4783f0b56077cb25800f898e2f4'
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
