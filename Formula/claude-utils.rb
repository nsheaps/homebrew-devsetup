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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.307/claude-utils-darwin-arm64.tar.gz'
      sha256 '92b3a8400179ed5bdf6cf5bed0d70b371e41da233dad22a03b80119b18d4c0e3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.307/claude-utils-darwin-amd64.tar.gz'
      sha256 '91faa1b673d51caf740e243518c993803e166d62d6d5dd9ac207f77bddf93c14'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.307/claude-utils-linux-arm64.tar.gz'
      sha256 'db5dc8f19a8eca7abdfd2ea129560a43b95e122ea61087ab7776325874d182b9'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.307/claude-utils-linux-amd64.tar.gz'
      sha256 '25f80c0d48049d976fbba2a7a9a14ebf7fde694556d1b95a78160b1e49d541f1'
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
