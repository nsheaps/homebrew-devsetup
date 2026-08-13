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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.265/claude-utils-darwin-arm64.tar.gz'
      sha256 '28ce7691bc0225e6654e3ef199c54b96441427d15f1f90a5013fbc2656708a72'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.265/claude-utils-darwin-amd64.tar.gz'
      sha256 'c8461711d3735333402928dc5148f9db787f3c833a4fee234e4c36b9599cb9c2'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.265/claude-utils-linux-arm64.tar.gz'
      sha256 'a6f7927c949a326cc55f4137235bb85c5fa4dbabd91226279a5f08810deb5328'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.265/claude-utils-linux-amd64.tar.gz'
      sha256 '0f18ce4ae90f207c2a0a876a2fa45283cc146994639cbb7a115b66b7a4817c3a'
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
