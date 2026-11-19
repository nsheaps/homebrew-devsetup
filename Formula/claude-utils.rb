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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.382/claude-utils-darwin-arm64.tar.gz'
      sha256 '22369a826cdeac7ce956cd07735bb7c255c9ff4d1e30c1a42e7b2fb96cfde2ad'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.382/claude-utils-darwin-amd64.tar.gz'
      sha256 '4b2dc053f2744f1c2364693995b57380d7a3e5f5427aacb26c1c61f51ac9eaa7'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.382/claude-utils-linux-arm64.tar.gz'
      sha256 '1c6ba11a68bdfd71b7fefed5f6987a303e6cb2c8dbfd8b099f67693f4dac2c6d'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.382/claude-utils-linux-amd64.tar.gz'
      sha256 '11dac2888edc1a3e4d71004bf2cd9aa4b90b4eda826e9d2be6e7de0adb3a8358'
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
