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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.260/claude-utils-darwin-arm64.tar.gz'
      sha256 '5c69db95755008ae9388f7db1461e835bfc4511d6fe5bfc291b4b86981ece7ed'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.260/claude-utils-darwin-amd64.tar.gz'
      sha256 '04e01971d73a86f3e7bd729db9a0c4416c4743be8722a6cdd7603b57c43fc34c'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.260/claude-utils-linux-arm64.tar.gz'
      sha256 'a578180af4ad18a4026c22e590ca55052a029929c1538794e3133c2771964e22'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.260/claude-utils-linux-amd64.tar.gz'
      sha256 '9e06d59fda1863b68fa820dac8aeb6b2625f49f21e827e9f12f20e0bc61962a3'
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
