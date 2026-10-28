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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.355/claude-utils-darwin-arm64.tar.gz'
      sha256 'b2c3d2e55811e02d59e6f979468675ec2cef7cbcb05bbffa7b8203b3eca22b17'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.355/claude-utils-darwin-amd64.tar.gz'
      sha256 '176da836551640bc85f702b9e465ed4e380a358b7f26b08817f6e300a369e0d8'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.355/claude-utils-linux-arm64.tar.gz'
      sha256 '115278ba118e6ab1015e20f83e8fe1c6bed7ae772b763ba18e3c407d04d74b73'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.355/claude-utils-linux-amd64.tar.gz'
      sha256 'a26e51fc6dba9f3883d4cc3f9cc3361dbf477272af71943dfed76cdb89c8b19e'
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
