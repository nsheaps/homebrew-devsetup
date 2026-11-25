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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.389/claude-utils-darwin-arm64.tar.gz'
      sha256 '077b9fa53efe2cc8eb9655f0c0a3c8b0c91dd0b4e0e93c4f6476a0afeb870a1b'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.389/claude-utils-darwin-amd64.tar.gz'
      sha256 '6066153ba875fad9fd7435b5478f750e7c2157468a5e99c0282d32e600e50f18'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.389/claude-utils-linux-arm64.tar.gz'
      sha256 '59e14799777d03a8d0ca5f9ffb31140ff39402019fe3d24e52d6661445abc199'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.389/claude-utils-linux-amd64.tar.gz'
      sha256 '42a0577de6bcb734dc9ed053e9e1aae7caef4316ae324831db8b2752455c3a79'
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
