# typed: false
# frozen_string_literal: true

class ClaudeTeam < Formula
  desc 'Launch and manage Claude Code agent team sessions'
  homepage 'https://github.com/nsheaps/agent-team'
  url 'https://github.com/nsheaps/agent-team/archive/refs/tags/v0.3.167.tar.gz'
  sha256 'ddc03fc817a8fbd646f0d1154fe0cc5de4f956d2327a1aa50e58b249a8a0b6af'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/agent-team.git', branch: 'main'
  end

  depends_on 'gum'

  def install
    bin.install 'bin/claude-team'
    bin.install 'bin/ct'
    (bin/'lib').install 'bin/lib/stdlib.sh'
  end

  test do
    assert_match 'claude-team', shell_output("#{bin}/claude-team --help 2>&1")
  end
end
