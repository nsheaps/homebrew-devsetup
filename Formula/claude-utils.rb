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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.370/claude-utils-darwin-arm64.tar.gz'
      sha256 '96ebd25d30781d365f917cbd5d08430ce0836d820d8ad06a4004761a2c7a692d'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.370/claude-utils-darwin-amd64.tar.gz'
      sha256 '3521d96296d2f195dc3acd0e5ca7181d578a5566d8ea8cb000e809da3bcb4bc0'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.370/claude-utils-linux-arm64.tar.gz'
      sha256 '3df4c14519a5626cc3d18a783c7ad1e0afb86ca6ee95dddae95ae10d2927c634'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.370/claude-utils-linux-amd64.tar.gz'
      sha256 '56b72616db3f6377dd13693d2280b2e4c89acebe88e322ef447c86aa9142a31b'
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
