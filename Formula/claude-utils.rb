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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.305/claude-utils-darwin-arm64.tar.gz'
      sha256 'e8bd9bb23d2faf44442cfd37f6a0116b9a69fa0cf1d49041f5fa4dab4aba1e8d'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.305/claude-utils-darwin-amd64.tar.gz'
      sha256 '7b0650068d6774e70200d14e753d053e0714c0ec6fd6e842ab9cd6bdf583c3ca'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.305/claude-utils-linux-arm64.tar.gz'
      sha256 '6632a08e9f5a747a934a3e304f5837c2b671c079b741b5ad02279ae25157f2b2'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.305/claude-utils-linux-amd64.tar.gz'
      sha256 '73fe628c36ba737cf0cfeca7de130064872fee2d375eb6685858124161bcc10f'
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
