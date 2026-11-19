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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.383/claude-utils-darwin-arm64.tar.gz'
      sha256 '36688232570114ef008fea454ef9262dd455337d84ad7dfa70d61dc0106817a5'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.383/claude-utils-darwin-amd64.tar.gz'
      sha256 'fffdbe5091daf7d87db1f9efe853067f105acb7c5dc348f73c922d3552ec42cc'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.383/claude-utils-linux-arm64.tar.gz'
      sha256 '64fb7045bb9c4da69079555c960b2c3c9638135e4aa1ac142bf429205f56f9ff'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.383/claude-utils-linux-amd64.tar.gz'
      sha256 '39e46b52c31b307981e379a702d7361ccdd0f177c4866131fc44d8a6c8336425'
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
