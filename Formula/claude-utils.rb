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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.283/claude-utils-darwin-arm64.tar.gz'
      sha256 'd7b956044e58e66b82ad31533e94b5e546ed356dc9c662001405e095d9a3f848'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.283/claude-utils-darwin-amd64.tar.gz'
      sha256 '5e1f4d61b24f49fdce04e150d9b7e60e0cbe2e1718eaf6e6b9747af84508c107'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.283/claude-utils-linux-arm64.tar.gz'
      sha256 'a4531cb84adcdbc3760c72407e9ca8dcbbf7ef9691dac6732cad0ef5a34e2c29'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.283/claude-utils-linux-amd64.tar.gz'
      sha256 '5edf7d9b748e0a0952141f7d0aeedbcdc14ac28938d224d010f1510b20d1a386'
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
