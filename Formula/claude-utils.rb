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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.342/claude-utils-darwin-arm64.tar.gz'
      sha256 'e1b593113679e0a9e469a2061bb626aa2b4d38d9b54c4708eb2b944ae2bedcf7'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.342/claude-utils-darwin-amd64.tar.gz'
      sha256 'a8cc18473dfe7553829168a49c70ce27d337a02c868ee3783581028499be0bfe'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.342/claude-utils-linux-arm64.tar.gz'
      sha256 '87211cafb68e83263093e87b6d4c67a3555b7af699c2227687fd62043644959f'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.342/claude-utils-linux-amd64.tar.gz'
      sha256 '1987ae038814a06456614fce10e2668807ae2578266b63778df118e5066e0eff'
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
