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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.364/claude-utils-darwin-arm64.tar.gz'
      sha256 '2844be317822307d715970e17b80649c6ae3b3886a1ce6083c9212edb54fb15e'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.364/claude-utils-darwin-amd64.tar.gz'
      sha256 '56a8286ec3c33289e546068d9e639db9d05e96bb180959636441d487aa9add2b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.364/claude-utils-linux-arm64.tar.gz'
      sha256 '5c8e4af3f1d7f0ae8d5da3e40d3e892e0dd1782443ff4fd6e2f62146d9f1258c'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.364/claude-utils-linux-amd64.tar.gz'
      sha256 '44949a1426a8f738b8e162897ff798a6fdd147d25e41ec2d901be0e670fd66f0'
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
