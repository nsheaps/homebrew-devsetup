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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.375/claude-utils-darwin-arm64.tar.gz'
      sha256 '84e5d2a05594339b72954c655cc27cc39bcd513c5f9e60965923739d2736ad31'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.375/claude-utils-darwin-amd64.tar.gz'
      sha256 '603991ccc9ede1145d61de270e92d58e7c5fac46a67f3c68bf11099a1371ad02'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.375/claude-utils-linux-arm64.tar.gz'
      sha256 'addbe3fcb8e4b91bdab258f5dc9e8ebaac25e3ba726c1f91d724efdb72bb2ec7'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.375/claude-utils-linux-amd64.tar.gz'
      sha256 '2dbb934f4db717512d15c8a9a037da30ca724d14bacffad49b856173184930d4'
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
