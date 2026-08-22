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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.276/claude-utils-darwin-arm64.tar.gz'
      sha256 '990930494358170723c3c40565192bad0e51b297fe149cb9a06e6cef63094a82'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.276/claude-utils-darwin-amd64.tar.gz'
      sha256 '977afb17869c9bd2f6e06d1968dc15f15afeca4a586f71352edaf1576c808009'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.276/claude-utils-linux-arm64.tar.gz'
      sha256 '1961297f739079137e0438c46fb8b7837720be8f5a22f896d91aa6b757386aaa'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.276/claude-utils-linux-amd64.tar.gz'
      sha256 'a6e078ee1d7e581ab78e2c4be09c2fe21bf4be8d6f89742480f74eb1532a39b1'
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
