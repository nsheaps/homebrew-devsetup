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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.296/claude-utils-darwin-arm64.tar.gz'
      sha256 'dd0270fa4d47a72c7b5c0e6f347f9d9e217adf96592e4da6df6b10ca7dc417ad'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.296/claude-utils-darwin-amd64.tar.gz'
      sha256 '444e8cfa925e85722d6df608658206318d5c202c2e0349818803519e4c7f2c35'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.296/claude-utils-linux-arm64.tar.gz'
      sha256 '409e9a4bb0115fabecde804391672932fda3eefd89a64463d32605b4bd674294'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.296/claude-utils-linux-amd64.tar.gz'
      sha256 '7d26dcb808425df51a7f4c66f436626ffef557ab7a3752be1dbb1034b65e20d5'
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
