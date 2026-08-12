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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.258/claude-utils-darwin-arm64.tar.gz'
      sha256 'e42e03976dc0fd30f8a2e128abc8d2d168e5055556a04aeffe00c1cb05a40646'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.258/claude-utils-darwin-amd64.tar.gz'
      sha256 '8b167f89c00cd3348daef27d19d4fa01a9116adf52c02ca47725470d68eb13b3'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.258/claude-utils-linux-arm64.tar.gz'
      sha256 '10d41b9ca17843cef605120062bfdc718b52cc60d352cc373633227a913eb6d7'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.258/claude-utils-linux-amd64.tar.gz'
      sha256 '0acb9875e8709e0d87761b5346718fc32757117031c635c9092a66dc3739b687'
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
