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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.365/claude-utils-darwin-arm64.tar.gz'
      sha256 '6b884d75eeef4fd6174fee578728c8e8d4cb6d50571e17ba6bf70ac67a554fd3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.365/claude-utils-darwin-amd64.tar.gz'
      sha256 'ffd1460a69bd18da2b8017d654516d5e25577eab30a7b9f99600c921faae0281'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.365/claude-utils-linux-arm64.tar.gz'
      sha256 '0d3a71ee22d69eb0d66eaa247600b816d69f417c615c86c185753d87e4a736b8'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.365/claude-utils-linux-amd64.tar.gz'
      sha256 '10ecd0eed8466e5d0ccddd50ae876de9d554d2b7681da740020ac95c108b442b'
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
