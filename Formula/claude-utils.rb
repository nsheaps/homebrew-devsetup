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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.288/claude-utils-darwin-arm64.tar.gz'
      sha256 'a7fe4ef26ec5e88a7afd01f2c26aa6f654cf5f0f1c92efadf318b537227d6009'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.288/claude-utils-darwin-amd64.tar.gz'
      sha256 '49e535eadc9127f65567a93bc7f93685dcb9bc2f7bd2732aed834b214c2ee54d'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.288/claude-utils-linux-arm64.tar.gz'
      sha256 '3a0c441ae8d7e69a8cb8aff163a4bf998cf083d6db56584df5d7673872512aed'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.288/claude-utils-linux-amd64.tar.gz'
      sha256 'c30ae0ef29313a04d093cdcf67e1c4fd179e400bf78d66f5cbd015e4c6134153'
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
