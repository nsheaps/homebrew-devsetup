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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.377/claude-utils-darwin-arm64.tar.gz'
      sha256 'ca57d89c8ebf949c13d703a4338168ebb67a7d9b29324b46fa74d5fab9467082'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.377/claude-utils-darwin-amd64.tar.gz'
      sha256 'eb7a9ea986e0340e2bf200ac103014bef227b1a7750275d07bdbf5cc9be5e99f'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.377/claude-utils-linux-arm64.tar.gz'
      sha256 '39724c6074a06710d57d4c6290dc42b6192222a3e9772173e7b318fcdd0939aa'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.377/claude-utils-linux-amd64.tar.gz'
      sha256 '290b9f4c8cf75465dbfe718d14454c16ab941756a773b949472eb05fc756230a'
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
