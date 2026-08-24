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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.279/claude-utils-darwin-arm64.tar.gz'
      sha256 '14ae324eed9c3fc57f41f61ffbbc2ec8642ad926caba99861ec2b6265101735e'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.279/claude-utils-darwin-amd64.tar.gz'
      sha256 '2f4e7d4b1bb63a597b2b493aa13c0df83d74fbc301425f267fca72bcb5152f80'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.279/claude-utils-linux-arm64.tar.gz'
      sha256 '7c616034698147e28eb6a227f97790ed8688c1303e6e06198e6f507425b60263'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.279/claude-utils-linux-amd64.tar.gz'
      sha256 '85c9694d9155e13b5cf8d5bb9f8ccaf74f006ff8344bfb4b1096a2c4b3009b21'
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
