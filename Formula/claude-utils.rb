# typed: false
# frozen_string_literal: true

class ClaudeUtils < Formula
  desc 'CLI utilities for Claude Code workflow management'
  homepage 'https://github.com/nsheaps/claude-utils'
  url 'https://github.com/nsheaps/claude-utils/archive/refs/tags/v0.12.67.tar.gz'
  sha256 '5f7ba3b12f06c477206c2d91bb1d7822fecdbd2390870eb9586ea95a24cc5281'
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
