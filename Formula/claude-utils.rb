# typed: false
# frozen_string_literal: true

class ClaudeUtils < Formula
  desc 'CLI utilities for Claude Code workflow management'
  homepage 'https://github.com/nsheaps/claude-utils'
  url 'https://github.com/nsheaps/claude-utils/archive/refs/tags/v0.12.223.tar.gz'
  sha256 'ece2f9e70ce766a6e530f47575c69338d9bac82e7e301846497e2d07c05788bc'
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
