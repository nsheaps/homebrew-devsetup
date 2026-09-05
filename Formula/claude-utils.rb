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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.292/claude-utils-darwin-arm64.tar.gz'
      sha256 '8a240fa5fc56f15fc9a10cc65c29cb9d24bd74f0e182fc4e00b20d4536481a75'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.292/claude-utils-darwin-amd64.tar.gz'
      sha256 '19611922ce0a7dc6381bb7a09c82f6f705e66e876203a3c39fc356b8bca68e32'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.292/claude-utils-linux-arm64.tar.gz'
      sha256 'a9960d57f3e316de3a87eee8d9cbffa5510d612d756992c14fc7ee6d9820984c'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.292/claude-utils-linux-amd64.tar.gz'
      sha256 '4040aa59651da9514c765cfeb51fa288ac1cf2546eac2c65205efcce3fcc69aa'
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
