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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.287/claude-utils-darwin-arm64.tar.gz'
      sha256 'cad49c86711967030c24fd1d3f18a2f4af86ffce130f4aaa001889b90f75e47e'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.287/claude-utils-darwin-amd64.tar.gz'
      sha256 'd3a59824fd83112f2f0c726a47578b290b1b787a528bcd7a96a85f61cda829a0'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.287/claude-utils-linux-arm64.tar.gz'
      sha256 'd24e9e5e048805bf9ff5f3cfab6c70e120d1f2cdd6f58a67337bb2494cc6a9ef'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.287/claude-utils-linux-amd64.tar.gz'
      sha256 '9c7b041cbae2a6c4cb465675f658930f70ec686cfb0c6619111be7a4b8c28f1f'
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
