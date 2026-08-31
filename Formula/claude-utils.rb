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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.285/claude-utils-darwin-arm64.tar.gz'
      sha256 '1521747323daf0abafb07408f3df1e01c8200e3ebaca989580ab689b3e61ca1a'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.285/claude-utils-darwin-amd64.tar.gz'
      sha256 'd61bcd827245eea98b1bfd77010b578075289b261ead5303739c1b3d4d70a2b5'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.285/claude-utils-linux-arm64.tar.gz'
      sha256 '859deca2a6144cb8af4f2908e4e88f8096f853b67d1dd1207f585b6dd27993de'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.285/claude-utils-linux-amd64.tar.gz'
      sha256 '8d236aa3dfb788a42ea883ce90fa6c0c4fed499da4e0ef94718364bf9b7d83f1'
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
