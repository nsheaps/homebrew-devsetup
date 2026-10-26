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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.354/claude-utils-darwin-arm64.tar.gz'
      sha256 'da1fe5641114391fd863ff76c59ce07a442bc50ab1cabb02e9826f6b5e7d4ebd'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.354/claude-utils-darwin-amd64.tar.gz'
      sha256 '077be074e4ef1b976f68e84ff286844b3d9f681ba0d0ab75be188746a9ffe9e2'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.354/claude-utils-linux-arm64.tar.gz'
      sha256 '2cca7677663c7c896d49f9149e9285a84832337194b1fab7b6d01199a7d3456e'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.354/claude-utils-linux-amd64.tar.gz'
      sha256 '2886c6edb66b236a87dd2809f414471e7d8fc804dac4c2b79324e7acabe824c4'
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
