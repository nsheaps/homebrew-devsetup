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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.250/claude-utils-darwin-arm64.tar.gz'
      sha256 '199ceb70bad33dcb250c5b78466a18630224cd7b53cfc5c57d78217e91f87815'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.250/claude-utils-darwin-amd64.tar.gz'
      sha256 'b6d96094a0ad19e7b26e1b5bb71f1b8c9cf30411f923587debf4bff78c35ec73'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.250/claude-utils-linux-arm64.tar.gz'
      sha256 '18222fec478dc20fcbd63827eebad858f12f9db2bc0cfba63486747034ba87c8'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.250/claude-utils-linux-amd64.tar.gz'
      sha256 '6e9a2e83148165d63c451c5c0fce1ed1da061e7e151af9310a084b626be311fb'
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
