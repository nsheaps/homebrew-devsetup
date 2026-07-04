# typed: false
# frozen_string_literal: true

class AgentTeam < Formula
  desc 'Provider-agnostic agent team orchestration for Claude Code'
  homepage 'https://github.com/nsheaps/agent-team'
  url 'https://github.com/nsheaps/agent-team/archive/refs/tags/v0.3.72.tar.gz'
  sha256 '3cbffc0ef68d7baf85ab249e489d1d246346cbb8ea812c818d17efa56d9db59e'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/agent-team.git', branch: 'main'
  end

  depends_on 'gum'

  def install
    bin.install 'bin/claude-team'
    bin.install 'bin/ct'
    bin.install 'bin/agent-launch.ts'
    (bin / 'lib').install Dir['bin/lib/*']
  end

  test do
    assert_match 'claude-team', shell_output("#{bin}/claude-team --help 2>&1")
  end
end
