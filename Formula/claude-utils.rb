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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.392/claude-utils-darwin-arm64.tar.gz'
      sha256 '9098a31ef08c4869107e5f7e64fc0f9e30828b82aefe20155dca21db9ea87a6d'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.392/claude-utils-darwin-amd64.tar.gz'
      sha256 'f204b64c824d9d5d357be12aa60069dd6dd8a80a29593dcf490c817158e9368c'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.392/claude-utils-linux-arm64.tar.gz'
      sha256 '4c086dea6ea00d6c5e762013f97332ca41893c91115317b84e06efc3c70f79b9'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.392/claude-utils-linux-amd64.tar.gz'
      sha256 '03e6f21e8ac8a2e52580097ab4024390536f75acb80813f49e8caeb24d1d6e91'
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
