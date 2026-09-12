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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.301/claude-utils-darwin-arm64.tar.gz'
      sha256 'd34e0c95c60acd3f444a3b5858bc2e884f8f2db7e9425f46b03a814fa04fc968'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.301/claude-utils-darwin-amd64.tar.gz'
      sha256 '47bd7099fcb4ee662ac22ea864654daf73b0f6e00b0fa103c8eee7f42b3d76b1'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.301/claude-utils-linux-arm64.tar.gz'
      sha256 '5d8270d540710172e80d8ed856513dc01e7a166d67f939c696f862160a48d9ea'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.301/claude-utils-linux-amd64.tar.gz'
      sha256 'dbdd85d31a4cca5a5db03c18320cbf53ebc2e4bb4e58738ef35aed1269ac5b9e'
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
