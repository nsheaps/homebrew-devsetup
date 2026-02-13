# typed: false
# frozen_string_literal: true

class ClaudeUtils < Formula
  desc 'CLI utilities for Claude Code workflow management'
  homepage 'https://github.com/nsheaps/claude-utils'
  url 'https://github.com/nsheaps/claude-utils/archive/refs/tags/v0.8.1.tar.gz'
  sha256 'fe6515340dcc262e602f5ac690c7c62a21c1c693f77e64270724d7cbe4dee81e'
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
