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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.252/claude-utils-darwin-arm64.tar.gz'
      sha256 'be8e59146194de6ce8a5f0f733c1bf90fa0733d42888085fc8af95c5c2adfd5f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.252/claude-utils-darwin-amd64.tar.gz'
      sha256 '97a2629e535a106d76a3609c3e967b5ac48dc267206450bf827c7117e8821021'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.252/claude-utils-linux-arm64.tar.gz'
      sha256 '12790ed0dfe6eeca2a7250bb05023afcb19bae93acc998e8fc39a1eacd4484e5'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.252/claude-utils-linux-amd64.tar.gz'
      sha256 'ee5c8c70eab0530a59014001326651767c7d43ff7d59fcbd41cd1269067ce986'
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
