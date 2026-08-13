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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.264/claude-utils-darwin-arm64.tar.gz'
      sha256 'a2e6f89d281f176f2c7cd6f361e96c78b6376b598cd61a6428fafc618d54c7c2'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.264/claude-utils-darwin-amd64.tar.gz'
      sha256 'c2a56b5ea268d7e2a124680d4b2bf519a1b8a35987ada35a95320f4dfa129325'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.264/claude-utils-linux-arm64.tar.gz'
      sha256 '0e029501e8681263fd0cac5ba7723da7b68248938d38616b11da4e886b6001e1'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.264/claude-utils-linux-amd64.tar.gz'
      sha256 'f2c2c33b963332ad898b3b68a6aa219bf15adc3690429ac46f05ea19d9a709d8'
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
