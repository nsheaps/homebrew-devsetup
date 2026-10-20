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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.347/claude-utils-darwin-arm64.tar.gz'
      sha256 '36307eebb61f979fdd0f2bd27baaf64d5b85f2946557f7ec43e40e52a29f3830'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.347/claude-utils-darwin-amd64.tar.gz'
      sha256 'd09c85849a3f516b1bf952ab277d27b8e7d5420e070bf2292f986c78b1bccd11'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.347/claude-utils-linux-arm64.tar.gz'
      sha256 'f644acdf5d2918a0fc1f26d0ffe874d027e93199d9e9658dd3bb351365881c92'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.347/claude-utils-linux-amd64.tar.gz'
      sha256 'e15da34e8ad092f2e01be637443f1fed740ae979f6ba93b4029b77713051756b'
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
