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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.289/claude-utils-darwin-arm64.tar.gz'
      sha256 '1e044a53f31593ff0c282963a31867ae29338c9308bf665a60f5933cb2d01933'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.289/claude-utils-darwin-amd64.tar.gz'
      sha256 '5e3cb56022dbd1385b754afadcc27e0c75445f00fc98dab528220b15a03ee318'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.289/claude-utils-linux-arm64.tar.gz'
      sha256 '7407ef2b4a15de79f935632037dd3e719b484cdb94bd81916f5e4cae14b75a15'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.289/claude-utils-linux-amd64.tar.gz'
      sha256 'ffe83452a35b929829e901186d319fb56cdf8d1c98e615c7865fe1ec22269166'
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
