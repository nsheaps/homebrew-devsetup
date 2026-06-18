# typed: false
# frozen_string_literal: true

class ClaudeUtils < Formula
  desc 'CLI utilities for Claude Code workflow management'
  homepage 'https://github.com/nsheaps/claude-utils'
  url 'https://github.com/nsheaps/claude-utils/archive/refs/tags/v0.12.86.tar.gz'
  sha256 'c77e8bfa459ef426eb5b1c34b77f7ba9f7b8a8f35893d60df5eca98e1425ec29'
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
