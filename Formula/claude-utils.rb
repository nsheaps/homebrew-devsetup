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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.266/claude-utils-darwin-arm64.tar.gz'
      sha256 'b1fb44f8bf07f3c9593eaf152d0f5ac82d7b3099205a54ed0afb1287844921db'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.266/claude-utils-darwin-amd64.tar.gz'
      sha256 'fd49d43d2e390f01f10f6012aa8619674adeb8c6a27cf25b5dd75013591bd53c'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.266/claude-utils-linux-arm64.tar.gz'
      sha256 '5fa0f2dd42a0433616a47245eabc136b4182fc0dbce34ecffd5c190e22f50f60'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.266/claude-utils-linux-amd64.tar.gz'
      sha256 '8229aa55129b9e6362c5a9401affecbcb0e7846c394ab06d7203254a9b6daa65'
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
