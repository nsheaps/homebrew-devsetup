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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.280/claude-utils-darwin-arm64.tar.gz'
      sha256 '41e5a4dfa40e68b2b9bd2364d1f6b642cb685d55fff06799906c136b1c857434'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.280/claude-utils-darwin-amd64.tar.gz'
      sha256 '59d6ed469d140f53115195afa59ee2428f38c5e80ab557f24eda5849247ffa06'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.280/claude-utils-linux-arm64.tar.gz'
      sha256 '3b7026995ba65814bcf57c72c5b8f8e7d6cc81d5d55afc0b38c9778f135880db'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.280/claude-utils-linux-amd64.tar.gz'
      sha256 '00363c7801a8a0e4f32b1d162ee81f7df515a19836188e0807ff682501cc23e2'
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
