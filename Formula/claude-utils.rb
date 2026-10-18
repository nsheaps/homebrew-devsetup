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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.344/claude-utils-darwin-arm64.tar.gz'
      sha256 'd7f4e7370f89c3cde4f7b03a7949a85994f5d95abae597093bc236cfb4458556'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.344/claude-utils-darwin-amd64.tar.gz'
      sha256 '25bb6c73c9f7230459a5a1b7c0769f86f65621f2f22ffd1eb14e16dc1aa0b5b7'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.344/claude-utils-linux-arm64.tar.gz'
      sha256 '47fb2e2d43233e33e5886f38baba2eaacec87fd50cf5720178c13f4d46281b76'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.344/claude-utils-linux-amd64.tar.gz'
      sha256 'd9bf381343cf0dc669d750b356de45bd2e4fe1448955d63c5c35e6251f2f6ebf'
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
