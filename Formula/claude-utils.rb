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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.267/claude-utils-darwin-arm64.tar.gz'
      sha256 '64297b9cb5c02b5aad5d23571f86ea8b609d37d8a78180e5e4900c71d006c953'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.267/claude-utils-darwin-amd64.tar.gz'
      sha256 'ed4daf05da80561da87ecef4938b1f602c90b580cd92a2fdb5e18350053572ee'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.267/claude-utils-linux-arm64.tar.gz'
      sha256 'fdf6ffce79c0c7110f93c7db1b5abfe559e12020007bc06950f62dbc928ec6b3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.267/claude-utils-linux-amd64.tar.gz'
      sha256 '7312f83c0226037c420d9cc2fa257170732d690694f1eacccbe594c92274687a'
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
