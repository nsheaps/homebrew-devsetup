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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.372/claude-utils-darwin-arm64.tar.gz'
      sha256 '40d68f2fd0d25cdb71c488019ff02abc187c8698c4dc1a9587c665979e278bcb'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.372/claude-utils-darwin-amd64.tar.gz'
      sha256 '5ef4f7677c46cca2bbe7d94377a96697240da35208687f28bf432d745e9107c7'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.372/claude-utils-linux-arm64.tar.gz'
      sha256 'd2a67dc6692e8643101ee1f82488c3ee4f4dd051b3502a5d459b8c470d8b34eb'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.372/claude-utils-linux-amd64.tar.gz'
      sha256 '411bca6c02c89c754c822cf1e8a760d50659fc9367fb18890cf6d51fb3d97cec'
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
