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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.359/claude-utils-darwin-arm64.tar.gz'
      sha256 '772a9f5e9c7a7dca3f9d5ca11dfe446e476a75b82546963321ab20f5892dbd49'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.359/claude-utils-darwin-amd64.tar.gz'
      sha256 'b546bbc86bf52ce00a469ed786882d39533f2ce9ee40bf6476840852601fe74d'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.359/claude-utils-linux-arm64.tar.gz'
      sha256 '8c00b89a352490c8a2004cd825bb9a861398b7610c152f86c3952104e8231c95'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.359/claude-utils-linux-amd64.tar.gz'
      sha256 'd4e385923994d83281b17af41494f003a038616632fe272d7264ca670c735566'
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
