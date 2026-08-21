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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.274/claude-utils-darwin-arm64.tar.gz'
      sha256 '90d6fa1a10619752d042acd89d3e80224a1eee7f83746eb2e6a2333d2c15b4c4'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.274/claude-utils-darwin-amd64.tar.gz'
      sha256 '9320abf409b5aad414773ae76b2c24e186db90d082a4e745b7cd1184d01d0a00'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.274/claude-utils-linux-arm64.tar.gz'
      sha256 'a9cec6cc5bec98aca7895287317b6b9ebfe03192dc415331fd8699e65baad3bc'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.274/claude-utils-linux-amd64.tar.gz'
      sha256 '49f0b669c5260c22d64a7ddb8ccd30c744af9dd6687b57d809f3f2646e7c6e81'
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
