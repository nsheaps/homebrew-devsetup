# typed: false
# frozen_string_literal: true

class ClaudeTeam < Formula
  desc 'Launch and manage Claude Code agent team sessions'
  homepage 'https://github.com/nsheaps/agent-team'
  url 'https://github.com/nsheaps/agent-team/archive/refs/tags/v0.3.189.tar.gz'
  sha256 '570d794e5f1bbb33ef6bd803c7806acb3f4774bc001005f1678aef46a3532391'
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
