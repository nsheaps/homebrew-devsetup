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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.361/claude-utils-darwin-arm64.tar.gz'
      sha256 '019652cf40f04fd0696c70e8f070ec52a7ff6679c60c5e62efae937d14f6fb83'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.361/claude-utils-darwin-amd64.tar.gz'
      sha256 '819ffaff7b61de31f49cf463b15b184bf2bb87db6df1afa3f83c1cf9fb591e18'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.361/claude-utils-linux-arm64.tar.gz'
      sha256 '235e4aed6573282cb076fefd31d8a32dbf8c78703648c041c79d0bdef254c6a3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.361/claude-utils-linux-amd64.tar.gz'
      sha256 '5de0f334475f9bda48bdc4342b17945e90545a33f178c74faab2ef32a069343b'
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
