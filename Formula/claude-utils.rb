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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.350/claude-utils-darwin-arm64.tar.gz'
      sha256 '74a9fb63e5ea8af570721ede28526f78e6cd473e02426d68b6d14d02dd8a0a5a'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.350/claude-utils-darwin-amd64.tar.gz'
      sha256 '7cf0e74135ac1d21e722fb4cae8d7617de65086b94a71e1a8f2cab2f1253a8ab'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.350/claude-utils-linux-arm64.tar.gz'
      sha256 'e115a28b89b6f2c1fc31a55c08bb54decb523a7619bb062c32cb245f95c429a2'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.350/claude-utils-linux-amd64.tar.gz'
      sha256 '2c5fe22ab0162d1008a46c821aeab565ce8d68be193a1e6604c52b70de934f3f'
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
