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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.330/claude-utils-darwin-arm64.tar.gz'
      sha256 '460645129073b7a704a3ccb3a307c0505c4500b66ae400f90a370eb2b5350b7b'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.330/claude-utils-darwin-amd64.tar.gz'
      sha256 'e63c324a32f9b8153cb682c8f2b975b450c383bf6ec92142d3f4d12cc328c3ab'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.330/claude-utils-linux-arm64.tar.gz'
      sha256 '84103c168183bdb846fdedac1d71f17fb4c3647d5221172acf611e17d981fd1d'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.330/claude-utils-linux-amd64.tar.gz'
      sha256 'd5e4cd8bdbed972e5aa8a45ae8ec427c754e73456d09e960b10fed9ca55ef857'
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
