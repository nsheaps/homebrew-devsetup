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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.362/claude-utils-darwin-arm64.tar.gz'
      sha256 '8643cbc46d3b289d5eb93ae325be23202aa001f4dde636057d75d172a56d15a3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.362/claude-utils-darwin-amd64.tar.gz'
      sha256 'bfb629951e41fa46cf53a2ad5750d9f97d75e95047e33687adf2671ad6088f22'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.362/claude-utils-linux-arm64.tar.gz'
      sha256 '0a959fe9bf52dc0b8d943222cb180ecf66cc61c7de7337b4eaa8341389d1e971'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.362/claude-utils-linux-amd64.tar.gz'
      sha256 '8c58cdcb6fa40b8d895d4b5dad1e0d2066881c5555d097c6e5b55b7cbf4cbcaa'
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
