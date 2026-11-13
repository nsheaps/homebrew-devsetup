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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.376/claude-utils-darwin-arm64.tar.gz'
      sha256 '90d391ae9f34cfc7478ff25d3f207854db7744c268b52dca81cca3f95098c39d'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.376/claude-utils-darwin-amd64.tar.gz'
      sha256 '31c94b3f0c7b71b9aabfad3c933030cf8b69f25b4bd356b0bc568b78b0727e74'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.376/claude-utils-linux-arm64.tar.gz'
      sha256 '6004a211722fc0960fb57d992d28995e037912396e73a7309237830b92cb2b2f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.376/claude-utils-linux-amd64.tar.gz'
      sha256 '03fd955741bb5b83b4d32fffd51f1c6d71b3772a69084cf8d3d2a113d64c95e0'
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
