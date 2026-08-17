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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.268/claude-utils-darwin-arm64.tar.gz'
      sha256 '41586c0177bd95b57572188f5cae187234576c10fe65ea81e391647adafe00a8'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.268/claude-utils-darwin-amd64.tar.gz'
      sha256 '1911696d8dd9cedbe5fcffc478dddef9f4c3fb77219bb5217e59d1d9ee28a29a'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.268/claude-utils-linux-arm64.tar.gz'
      sha256 '5d1575e4622edb70a0d90abc22e71a424e9a275bf67c6de9875b0f7a813c506e'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.268/claude-utils-linux-amd64.tar.gz'
      sha256 '4d3c6245980e2f59e70824b253c530a47a67d3cedd09d08dd5837c36359e0617'
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
