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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.351/claude-utils-darwin-arm64.tar.gz'
      sha256 'a5ba43b1219a1062bafed08fa072995b8417c9eac69ef2f805e3af8bf2301e2a'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.351/claude-utils-darwin-amd64.tar.gz'
      sha256 '3195c60e060c74516369f7b83fd8de283277743e9b73c46997edb6f373c165f4'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.351/claude-utils-linux-arm64.tar.gz'
      sha256 '3292e0f4e11c87aba968bc47793e6d84d4ed95d64682942dd9be3023798ba339'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.351/claude-utils-linux-amd64.tar.gz'
      sha256 'e155c2aa2b47acdb3946009ebd9ed0c7ac656deedb9a412c13213d44d8e5390f'
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
