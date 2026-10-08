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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.331/claude-utils-darwin-arm64.tar.gz'
      sha256 '33d319b1d92a74f147198ba984707b66827d1777664c8190733615a13fe53491'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.331/claude-utils-darwin-amd64.tar.gz'
      sha256 '3fc4a57c84634a632a2516e6a5c3a7ef408b6faf919825707fc82dc3388a220b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.331/claude-utils-linux-arm64.tar.gz'
      sha256 '62b51b75498a7015f33ea2dec3d7494cd43d9ccb1ecb3ba6250109211d1bb988'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.331/claude-utils-linux-amd64.tar.gz'
      sha256 '96e76dffa3987ccd686316b69abb0c9beadb5b6d7b0859f7a7c7198bf4ea6fc6'
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
