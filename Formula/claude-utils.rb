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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.259/claude-utils-darwin-arm64.tar.gz'
      sha256 'd8abf5a73aa27e716b4f98187bd9f058bb1e458daddcc01a0c9a8a3621def9a5'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.259/claude-utils-darwin-amd64.tar.gz'
      sha256 '91e76e16cd82023a4ca3d34b767ec611fc7a04303de37987256061bf0d1919ea'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.259/claude-utils-linux-arm64.tar.gz'
      sha256 '5b6fa39fd74e38c751dd0687a6e6dedf5061cfd94eaddc77115a5c8276998163'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.259/claude-utils-linux-amd64.tar.gz'
      sha256 'adcd23d70771f26540003ca2db62feb2c4cd3e5f59a75272381e8354be80edf5'
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
