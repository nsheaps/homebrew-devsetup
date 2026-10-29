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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.358/claude-utils-darwin-arm64.tar.gz'
      sha256 '6f042248b58329683044054330edb944cd9c0086282a3349bece79777cf0714e'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.358/claude-utils-darwin-amd64.tar.gz'
      sha256 '8fa097851674bc4983131bbb6d6b27da2df044c6c7a0356de8b59a14f787db4f'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.358/claude-utils-linux-arm64.tar.gz'
      sha256 '1233f5ed610b203cc0bdd0e3c237752fe5ab9e3486ca0d0d74e1e1fb9787e150'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.358/claude-utils-linux-amd64.tar.gz'
      sha256 '17310b7ae8638b7091eea08e65f5ab4e4491477774c126642b37746a7f6d542a'
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
