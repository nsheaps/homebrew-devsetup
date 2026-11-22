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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.387/claude-utils-darwin-arm64.tar.gz'
      sha256 '58dcce13fed285bfe7f8436ea713e3c270518529fa9caa0012477d642aaa20d0'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.387/claude-utils-darwin-amd64.tar.gz'
      sha256 '57d377b04fde4485aca96bf8ca71d378e908d2c18a042e2a97fe70cd065ef4d0'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.387/claude-utils-linux-arm64.tar.gz'
      sha256 'cedc728953eab62385cb183e6a5f03f1d88c4b1422f8d2f005b90564170b8efb'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.387/claude-utils-linux-amd64.tar.gz'
      sha256 'e327f44058df6bdd6d57c72e408db65477a59e0091d91096c0382e0f393c30b1'
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
