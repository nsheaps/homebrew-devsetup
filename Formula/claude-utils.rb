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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.278/claude-utils-darwin-arm64.tar.gz'
      sha256 '8785b8d9f8e2ca6da7e4013525d7c2d660939a954f052471e6d421618b035567'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.278/claude-utils-darwin-amd64.tar.gz'
      sha256 '8ef5316f66b8f40c84a1a55203c11c9627c8bf1906506c5570f03dfd3b950a24'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.278/claude-utils-linux-arm64.tar.gz'
      sha256 'baafdf49a483a5a5c3181cc860ae4300785591e46b22813e29e1ead5c2ebd08a'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.278/claude-utils-linux-amd64.tar.gz'
      sha256 '90f630a760715c65b67518bca641baeea3da1a6cb74dacf57ba02f9591e5ba11'
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
