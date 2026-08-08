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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.248/claude-utils-darwin-arm64.tar.gz'
      sha256 'e675c0ae6b1e52022a4c1c172d642bbe8de4f323b2f57f3886d8d3217b4c6970'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.248/claude-utils-darwin-amd64.tar.gz'
      sha256 '5a6ba11b6c2339d676af5c0d7d56f8eab0c0cbed422c4178d762f0253b578737'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.248/claude-utils-linux-arm64.tar.gz'
      sha256 'da15c9999d5174ef47a91f88def4998747e7749a2360e5d7b9444aa4646f5b6e'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.248/claude-utils-linux-amd64.tar.gz'
      sha256 '4751ceefd6e6e408089f055181c3d6004b199b59a176618867ef3cfe07b17c68'
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
