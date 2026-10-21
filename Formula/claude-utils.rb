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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.348/claude-utils-darwin-arm64.tar.gz'
      sha256 '58218e2f8c7b8daf0ea5ff5cd14b46c8aecb9579ec45e54422444fca9ff1d442'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.348/claude-utils-darwin-amd64.tar.gz'
      sha256 '9910d378545953aa810bdd95d92e2eed28dbb02ebe5a8c1138b9f7187d2baaf7'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.348/claude-utils-linux-arm64.tar.gz'
      sha256 'ee930d177f3c11867ca64110497f41449e677bc4c918da8cce2c5840fe8ed1db'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.348/claude-utils-linux-amd64.tar.gz'
      sha256 '98be1177df63436ac7928f10e6039192e3f58eb27cf52bad7b9754903f57e0b3'
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
