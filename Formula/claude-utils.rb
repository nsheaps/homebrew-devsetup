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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.337/claude-utils-darwin-arm64.tar.gz'
      sha256 '382630aa704c7595a127cfa840fa0a13ab36e2669d7d27d3c797b4fc3003e0ac'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.337/claude-utils-darwin-amd64.tar.gz'
      sha256 'a74ae36d9a89c458b7aff6bc3d08b01998b8e3a563c43179a2c38fdfe84338a2'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.337/claude-utils-linux-arm64.tar.gz'
      sha256 '32fe4805046f6558ee466039c1c4f8c329e6101f21ce650b53b2f2a776ff17d1'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.337/claude-utils-linux-amd64.tar.gz'
      sha256 '3d05a12341ee0a251e12265f241e125411f179b788ee11e377527969028961db'
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
