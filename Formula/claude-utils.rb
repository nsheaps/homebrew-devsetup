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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.339/claude-utils-darwin-arm64.tar.gz'
      sha256 '19f4e25b7cd6ddd0501cc4c47b903638d33a21960931f562337d4a57196acb8a'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.339/claude-utils-darwin-amd64.tar.gz'
      sha256 '69c733c355b05e89f629f1c6f915390eff7ecb74e4c0b4ceb03b4b5197f0a373'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.339/claude-utils-linux-arm64.tar.gz'
      sha256 '18e13a4118890a73a23de4fbe8ef41ea64f6909fc7c93ecac832e46e7d7142b0'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.339/claude-utils-linux-amd64.tar.gz'
      sha256 '4d779c7016aa933dfd99bd19d373bcb122e7d5897ff7236da06b394b951e6fdb'
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
