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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.311/claude-utils-darwin-arm64.tar.gz'
      sha256 '6de5ee2deea3cb7c88c463b2d127cbb968479d6b02b4d7dbde33b567a0d01b80'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.311/claude-utils-darwin-amd64.tar.gz'
      sha256 '891a8eb1b7284e24bca363d1780889086c9ed8e6c4614e2741cd5666ee011f83'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.311/claude-utils-linux-arm64.tar.gz'
      sha256 '8e8788e14450614df04be4d3b312b5f6d5f003e4e52a2f0531f1be0a65a8ac82'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.311/claude-utils-linux-amd64.tar.gz'
      sha256 'd908d01bcb4af25d4e9cdaaa50e009f007852cf9d948ed39d76080b995c68262'
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
