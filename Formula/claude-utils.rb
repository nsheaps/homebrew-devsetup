# typed: false
# frozen_string_literal: true

class ClaudeUtils < Formula
  desc 'CLI utilities for Claude Code workflow management'
  homepage 'https://github.com/nsheaps/claude-utils'
  url 'https://github.com/nsheaps/claude-utils/archive/refs/tags/v0.12.21.tar.gz'
  sha256 '153c068de5b944fb93f62c48ab588d19506bfab7e809e71e8376bb0f6476191a'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/claude-utils.git', branch: 'main'
  end

  depends_on 'fzf'
  depends_on 'gum'

  def install
    bin.install Dir['bin/*']
  end

  test do
    assert_match 'ccresume', shell_output("#{bin}/ccresume --help 2>&1", 1)
  end
end
