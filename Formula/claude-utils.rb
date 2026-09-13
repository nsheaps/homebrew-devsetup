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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.302/claude-utils-darwin-arm64.tar.gz'
      sha256 'cfda2f08df67dcf05594c6a79be62b4de6d18ec39831b7f5f0f2de2caed6ab39'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.302/claude-utils-darwin-amd64.tar.gz'
      sha256 'ac301aa1d003b1734ead9a413390751fb975e143012c402abb1e7a323bfa5dfc'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.302/claude-utils-linux-arm64.tar.gz'
      sha256 'cbe4ec566f8608c61bd425a4981baf4a37ed6319d87f69cbe5cdac483cf98a35'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.302/claude-utils-linux-amd64.tar.gz'
      sha256 '110d1917f682896c4379903ccdbf9dcea661d4737108cef4a255fdf3546f2a23'
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
