# typed: false
# frozen_string_literal: true

class ClaudeTeam < Formula
  desc 'Launch and manage Claude Code agent team sessions'
  homepage 'https://github.com/nsheaps/agent-team'
  url 'https://github.com/nsheaps/agent-team/archive/refs/tags/v0.3.87.tar.gz'
  sha256 '4f76d70ad0c2e3b62ae626e9312540944fdf1951bca95ef5da17e9e7a5bc89c0'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/agent-team.git', branch: 'main'
  end

  depends_on 'gum'

  def install
    bin.install 'bin/claude-team'
    bin.install 'bin/ct'
    (bin / 'lib').install 'bin/lib/stdlib.sh'
  end

  test do
    assert_match 'claude-team', shell_output("#{bin}/claude-team --help 2>&1")
  end
end
