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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.277/claude-utils-darwin-arm64.tar.gz'
      sha256 '572bbd7859ad90e63a6841fb121ecc69bf99b33b0b0cbd8294911ba070188f06'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.277/claude-utils-darwin-amd64.tar.gz'
      sha256 '6bd353c63cc0cc59ca88bef67dca77631d5ac46e815c29b3f7e063d83bda76f1'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.277/claude-utils-linux-arm64.tar.gz'
      sha256 '68c5fc42b6bd16db182a45b3b92f3fbeb08e8309b72c72e4657ecddd98e1f954'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.277/claude-utils-linux-amd64.tar.gz'
      sha256 '4c8a16d48ef10c67419b97149497fde570317c85d35c1705c9747e9cf2acd502'
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
