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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.388/claude-utils-darwin-arm64.tar.gz'
      sha256 'ca1874ca9b88d409283196a18aa9141bfd954c1d20d9f4c7efb9137661f98267'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.388/claude-utils-darwin-amd64.tar.gz'
      sha256 'ba4ad91ec17489d98be244f433c78b5d084b7ddae370fdc1d0a0719e0323e5a8'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.388/claude-utils-linux-arm64.tar.gz'
      sha256 'ff4db4d0aa53138150c85ec4d4a240463371201e8fd804e55b8b80508fdd7ef3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.388/claude-utils-linux-amd64.tar.gz'
      sha256 '3bc92b9d60bf740cfda2f2df108db0836a1d8e5826560f6cb9acd3bd1bf40b6f'
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
