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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.349/claude-utils-darwin-arm64.tar.gz'
      sha256 '2e3442995de36fea112c0f0c80e1551afb74755a7f465a06a828b0a62e2dc0a5'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.349/claude-utils-darwin-amd64.tar.gz'
      sha256 '9a0827298bd2e1f73eb811764ac795ae29650c5d2e2756a4b96c8a6d5b56ba63'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.349/claude-utils-linux-arm64.tar.gz'
      sha256 '0e093b44b477c738007bfcc037b24576aaa776b502c0b643b73e8e85d1f6773f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.349/claude-utils-linux-amd64.tar.gz'
      sha256 'c050512bd136d6f718db59a809fdd9f61f37479d50b118660de8d97db3fa2a26'
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
