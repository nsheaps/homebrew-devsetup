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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.343/claude-utils-darwin-arm64.tar.gz'
      sha256 'e9bd313464a66870e328015f5cac5bd4eef822c4f9c24b678ee304648623f8a8'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.343/claude-utils-darwin-amd64.tar.gz'
      sha256 '27b04d33ae71a2e732adb0276ded856bbc678229ba329ad1d15d6db39fd63676'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.343/claude-utils-linux-arm64.tar.gz'
      sha256 '1b8bcf5877a33596edcadce732b228bfd147592e11a1bf5a7706dce89d4dfa42'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.343/claude-utils-linux-amd64.tar.gz'
      sha256 'c63253db95fe6d1a42d62fe6664cc2025dcdfcfe7e516dc40feb47309f33f131'
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
