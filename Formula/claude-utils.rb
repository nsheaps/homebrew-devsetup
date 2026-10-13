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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.338/claude-utils-darwin-arm64.tar.gz'
      sha256 'b7329ecba092281fc1b9ca5ce632a07c55f37069496c2c239329ea980713f1ba'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.338/claude-utils-darwin-amd64.tar.gz'
      sha256 'c67bd989af48fbdcd979e34e39375cd0bc4ebdf1049c2d91463fe8cf7841309d'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.338/claude-utils-linux-arm64.tar.gz'
      sha256 '5c8120eced80991ac3fe9872d0638b8b146f07c7f595f54954430c6f2c6acdb9'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.338/claude-utils-linux-amd64.tar.gz'
      sha256 'e7b5983929868b2415a7fc01828e5ca5153b8652c7562926d458cec7f798d351'
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
