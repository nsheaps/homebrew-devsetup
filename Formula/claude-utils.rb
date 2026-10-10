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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.334/claude-utils-darwin-arm64.tar.gz'
      sha256 '340b78f2e8ccd0949c8298c73178f09a9036f5f5fb5d977c34d20d2c89002ad6'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.334/claude-utils-darwin-amd64.tar.gz'
      sha256 'b0656e33173c84420ce4815390e5bf4050089278955edc2b1b65b0fed7bd06d5'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.334/claude-utils-linux-arm64.tar.gz'
      sha256 '8d3f7a3847fcde9f8a9f326660a9d0a2ee2fe8e891aec97ba3d0d4d12f4bd815'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.334/claude-utils-linux-amd64.tar.gz'
      sha256 '37b8070a0807a7dd7b44da0bde95e319f117e521554dbc1c7707729e024c6b50'
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
