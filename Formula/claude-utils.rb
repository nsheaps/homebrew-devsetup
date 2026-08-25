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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.281/claude-utils-darwin-arm64.tar.gz'
      sha256 '6f3d5a549342c8424d55e46dcc3090f8977b16f55f9311d147733b85b66e9622'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.281/claude-utils-darwin-amd64.tar.gz'
      sha256 '3fb59d743eb55258efe01509f6d295b9eb8327962cd21110126a7be09b910bc3'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.281/claude-utils-linux-arm64.tar.gz'
      sha256 '40ded3bc4b380806ea30a380f77d4c10fc4e52e3406a85b81d0bbf71e766dc47'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.281/claude-utils-linux-amd64.tar.gz'
      sha256 '288882f935d8eab90560d2c87d45089e5fc85a80793f2e7440f06c91c38d085e'
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
