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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.381/claude-utils-darwin-arm64.tar.gz'
      sha256 '82efc6d7a14b24bb8bd38758a32359a154c89c8e77b27210f2c6a814b70ec37f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.381/claude-utils-darwin-amd64.tar.gz'
      sha256 'c87bab828e709ef082e705aacde4cc91994c187b93ab3ee660d9fc59a7af76c1'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.381/claude-utils-linux-arm64.tar.gz'
      sha256 '7c1d81d2828a3a6319d845795e875d5b751afa289f89725107b0aaccb0f3b95c'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.381/claude-utils-linux-amd64.tar.gz'
      sha256 '75aa0ed33c34c8153e0e808a9bea14e98f117b9641caefc173ac3d917e2342e5'
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
