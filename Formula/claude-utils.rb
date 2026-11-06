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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.367/claude-utils-darwin-arm64.tar.gz'
      sha256 'b840b25becb14c64d8630bd83d3346ce44152e431d4fc0abe852aeb1e44d7d0d'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.367/claude-utils-darwin-amd64.tar.gz'
      sha256 'ff7bbbd5c1927bc339710ea9682cda54227ea11360bc17555ee3b0acf7c3772a'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.367/claude-utils-linux-arm64.tar.gz'
      sha256 '810154f656a64ba86fc90d37170b66ad073af422f9b8f0628030a186c4f02b9a'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.367/claude-utils-linux-amd64.tar.gz'
      sha256 'ca79cfde84b879a07279188f8ea2235e6cf8e9b9ac8cc3d330f22dac2c37730d'
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
