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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.308/claude-utils-darwin-arm64.tar.gz'
      sha256 '3448eb4af6ba6ac47663ea1469180cb471bc1d31f23ade0a17f1e93957b1266d'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.308/claude-utils-darwin-amd64.tar.gz'
      sha256 'ed50867c2b0dc71328940e5ad13378ae5ac642b09d9c370f36f6dddc07e512bb'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.308/claude-utils-linux-arm64.tar.gz'
      sha256 '6edccf3e848848d184885b35fc256b165c8a622238acfea530a7310945a2265f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.308/claude-utils-linux-amd64.tar.gz'
      sha256 '729a2ee51601315e83f7669fdf8a4bee1f14d396d6eb6d7887af37583736c2b7'
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
