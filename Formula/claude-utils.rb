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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.323/claude-utils-darwin-arm64.tar.gz'
      sha256 '18b9b6399c8220c551fb0b3358e6b0f6d39499f900d1a4bd14c0bef05612517f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.323/claude-utils-darwin-amd64.tar.gz'
      sha256 '681f4bd09416525927d35e5fa05bb1c86a5287754c5427987fed0c7aef63c2ed'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.323/claude-utils-linux-arm64.tar.gz'
      sha256 '9d6e77f00ee2b30da2c607fb23955982aa3e1ae6d4e2b935d2136b688713b5ad'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.323/claude-utils-linux-amd64.tar.gz'
      sha256 '7b812884eec17a3b67f06ea11a0210c53872cfd7d1a69aa192bbedbea2eba9fd'
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
