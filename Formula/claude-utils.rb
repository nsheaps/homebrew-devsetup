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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.293/claude-utils-darwin-arm64.tar.gz'
      sha256 'b9368c9bdead1a9f2ecf02823303099a0c58d5d86b52a20af90ba10237845e5c'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.293/claude-utils-darwin-amd64.tar.gz'
      sha256 '0a4aec38178078c16f2a5bcaef55e47ebb703b4fab17c60d3139d3b190d537b1'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.293/claude-utils-linux-arm64.tar.gz'
      sha256 'b89726355c01591541971b36830d205e70d8d0a86385abb6894a4afcc9ab860d'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.293/claude-utils-linux-amd64.tar.gz'
      sha256 '3f7c747ce7e988dced93178e9aa87e2d9fb43b06bf40fa468faa0a6b0fc9cb1e'
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
