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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.273/claude-utils-darwin-arm64.tar.gz'
      sha256 '7ef667f4cbef4ba27167e4b6f532c637183775b1b13a1aeb67beba676aa04620'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.273/claude-utils-darwin-amd64.tar.gz'
      sha256 'e4002d58102084b0ce074ff59bb15c9be9d5d9ee8c528a2c9a0ea119d606a33f'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.273/claude-utils-linux-arm64.tar.gz'
      sha256 'aabf80b6bae48d1099bd2a914390db66913d909afb31ae99848f0999064e07a2'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.273/claude-utils-linux-amd64.tar.gz'
      sha256 '93ce7d4aa78a78249611b9f98dd0d6ac19ef37f99eb55005e711f3da9c24597c'
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
