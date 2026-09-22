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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.309/claude-utils-darwin-arm64.tar.gz'
      sha256 'ec8eb995d439f02c9d8f05824f4912a9dfd4be088a6a3c0f25615fc98ccab77f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.309/claude-utils-darwin-amd64.tar.gz'
      sha256 '69454b16556f0d36ec6480f058adedc3b156d6053cf7073a483bb6118ba37a09'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.309/claude-utils-linux-arm64.tar.gz'
      sha256 '4131e21246141aeb8c0626646e54cf3e085798c70588e4af41dc077be8b4d884'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.309/claude-utils-linux-amd64.tar.gz'
      sha256 '5d7c339f5af9350b428f906cb66ab061e2aecd74bc7fd2bd78823052f221f243'
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
