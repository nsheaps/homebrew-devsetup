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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.357/claude-utils-darwin-arm64.tar.gz'
      sha256 'c1cd77d9799a126e7d36a89215d7f96f9d3629c42af7f6f357a22ce3b7bf6b82'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.357/claude-utils-darwin-amd64.tar.gz'
      sha256 'c52638693a8d49c95cf918f6a4884637426e7ddc094f008719e10692152322bf'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.357/claude-utils-linux-arm64.tar.gz'
      sha256 '1990cd52c23b841894e0342fae7111e76a8613300e70f1f34de1222e9eecfab2'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.357/claude-utils-linux-amd64.tar.gz'
      sha256 '91e31e09eb426c9415c6b6be78f57e81cf8887a3c74947a7b372b16463052bff'
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
