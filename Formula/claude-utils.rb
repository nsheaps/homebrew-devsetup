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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.256/claude-utils-darwin-arm64.tar.gz'
      sha256 'd0f769d146322e7574bebcaa80a35941f0155648d874f01506d5961daefeb81a'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.256/claude-utils-darwin-amd64.tar.gz'
      sha256 'fdf94a18bc13d6f5cecaa2bb81ec61332c03f230c4c3bd5c50da06c88097b1db'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.256/claude-utils-linux-arm64.tar.gz'
      sha256 'b751ae3dac614a505ea5b7a8cf2cc65f2f770dc3da275828c1947a0b80dfc710'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.256/claude-utils-linux-amd64.tar.gz'
      sha256 '8a1df29a46a740d6f992306f2988fdd7b82d08c80e0ed8701ae2fe22dbda8e99'
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
