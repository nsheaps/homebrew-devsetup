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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.275/claude-utils-darwin-arm64.tar.gz'
      sha256 'a9016ec6f34430a465e5ff1a8382bcdc596ec4d80df3287a855b8f4c7d017035'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.275/claude-utils-darwin-amd64.tar.gz'
      sha256 'e33dfc0467ef21afce05cec54e0c33bfc51e4d510bbe659b87193d6755a68d11'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.275/claude-utils-linux-arm64.tar.gz'
      sha256 '7d236271876a3f0df25e15973af1cf2512e45235a1dfb31b77e7cd0242f07dee'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.275/claude-utils-linux-amd64.tar.gz'
      sha256 'e05b83cf6d5c0963d70e09964cb3b33068761e84aa6ace54ef6831716ef7f5dd'
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
