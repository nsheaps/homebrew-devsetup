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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.255/claude-utils-darwin-arm64.tar.gz'
      sha256 '314166c9319746b5e0ce27e130d15306e35bc53ff36f117e5b27260e257b311f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.255/claude-utils-darwin-amd64.tar.gz'
      sha256 '3a0478e3fadf20c678e5a2980cdaf3855f1677dff4d38d5d440a1a14d6c42976'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.255/claude-utils-linux-arm64.tar.gz'
      sha256 '453062991169f0edfae6a2421b3da6dd6f2397fea53eb1ccf722149d899be97f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.255/claude-utils-linux-amd64.tar.gz'
      sha256 '6846f8398d8b6f780a52d1e986fa5fff31211d3748553286e2fd4f0a565c32f5'
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
