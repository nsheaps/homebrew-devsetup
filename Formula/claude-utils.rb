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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.249/claude-utils-darwin-arm64.tar.gz'
      sha256 'd63f1ee13d1979beb8f3d0a70416622dc4b5408b6343082c86371106f915d3c3'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.249/claude-utils-darwin-amd64.tar.gz'
      sha256 'd081a28449d878121c891dd62718aace1d753a807cd164b963a9d90b81212bc0'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.249/claude-utils-linux-arm64.tar.gz'
      sha256 'ff00ee703e77540340f31cabe4f7880d4d8dc0e358ad197f2ca1cdf9c80f198b'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.249/claude-utils-linux-amd64.tar.gz'
      sha256 'f867203abee17576404b12c0f6b8c09e5cafe28e5e39c87422e1fcdf7b0c9a5f'
    end
  end

  depends_on 'fzf'
  depends_on 'gum'

  def install
    bin.install Dir['bin/*']
  end

  test do
    assert_match 'ccresume', shell_output("#{bin}/ccresume --help 2>&1", 1)
    assert_match 'Usage: agent-plugin', shell_output("#{bin}/agent-plugin --help")
    assert_match 'Usage: agent-hook', shell_output("#{bin}/agent-hook --help")
  end
end
