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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.257/claude-utils-darwin-arm64.tar.gz'
      sha256 '05e121053e625334af828ad06316badbf706346cd13516b77a001e7d19015151'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.257/claude-utils-darwin-amd64.tar.gz'
      sha256 '7607e22349fad548d5282128b273a5106e550f5a030ba4ff3a3972e153471e39'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.257/claude-utils-linux-arm64.tar.gz'
      sha256 '3336e1c0bd2f8c16df327cba3f46a373cf23370a387accffec3f973872ea444a'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.257/claude-utils-linux-amd64.tar.gz'
      sha256 '24e52e14fdf5dcfcb0a4d9395c0c377ec4ed8f73fcd49628e8b6c755c07b7c59'
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
