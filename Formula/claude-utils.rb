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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.298/claude-utils-darwin-arm64.tar.gz'
      sha256 '47f91e2efc3a2eab0fd6c5190b15b2a963260276a7ed61dac871169537b14a26'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.298/claude-utils-darwin-amd64.tar.gz'
      sha256 'ac5d0a26144574e51ca05195535072b24022247e481968a22124835a614293f9'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.298/claude-utils-linux-arm64.tar.gz'
      sha256 'ff0a1b43750b2603719a5b526814b9e2d6c4d11c70ee562cdfe15fa6aa1260c0'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.298/claude-utils-linux-amd64.tar.gz'
      sha256 '61d9b2ebb729934d5eb67f54a1a421fd6f64759c6a2c8cd3da8880c5e8fa0cb1'
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
