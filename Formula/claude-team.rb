# typed: false
# frozen_string_literal: true

class ClaudeTeam < Formula
  desc 'Launch and manage Claude Code agent team sessions'
  homepage 'https://github.com/nsheaps/agent-team'
  url 'https://github.com/nsheaps/agent-team/archive/refs/tags/v0.3.169.tar.gz'
  sha256 'f695634549c27ced7475fa33870d341a29ceec1a90e40d80dd021d7563d296d8'
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
