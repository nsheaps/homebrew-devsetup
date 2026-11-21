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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.385/claude-utils-darwin-arm64.tar.gz'
      sha256 'dd3468f0817673fef135db21cd6f56b0fba411f1568d3047968d900700a4f235'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.385/claude-utils-darwin-amd64.tar.gz'
      sha256 '9aae649c593662e7daf03cd4ceffac942f93ceac5de201ad45d5d4ee3eeb0adc'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.385/claude-utils-linux-arm64.tar.gz'
      sha256 '973d0ab5d5f2fca08ad1fe8cb337cd32f23f9893aa94567fe8b05a23252eb148'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.385/claude-utils-linux-amd64.tar.gz'
      sha256 '9ce69f66678efb28e71a67ad227ef199e9ee5b4b8cb6a69b5bcd08097381e62b'
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
