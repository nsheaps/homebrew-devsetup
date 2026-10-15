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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.340/claude-utils-darwin-arm64.tar.gz'
      sha256 '1d3e2aa24b99147741cd04e7753c514b067cb31958760bab1ee863cd76c405b3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.340/claude-utils-darwin-amd64.tar.gz'
      sha256 'dffc6c2e4034eec46974e884f32e1b211b793e0c3a3b982ed601400a98c104fd'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.340/claude-utils-linux-arm64.tar.gz'
      sha256 'eea0da5409424c415be6df974daf2c9ac70f9c85c50f527a98d4e615b4d33541'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.340/claude-utils-linux-amd64.tar.gz'
      sha256 '25975623bf424e3d6845e0e5ecb7caa13c0c1d177f7f3375309bd29ab7d05907'
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
