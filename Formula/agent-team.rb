# typed: false
# frozen_string_literal: true

class AgentTeam < Formula
  desc 'Provider-agnostic agent team orchestration for Claude Code'
  homepage 'https://github.com/nsheaps/agent-team'
  url 'https://github.com/nsheaps/agent-team/archive/refs/tags/v0.3.192.tar.gz'
  sha256 '6a5eaa3e2a940b6bf6cb9c24074c12dea63b5c5f9a157eb1e75df4fd191759f4'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/agent-team.git', branch: 'main'
  end

  depends_on 'gum'

  def install
    bin.install 'bin/claude-team'
    bin.install 'bin/ct'
    bin.install 'bin/agent-launch.ts'
    (bin/'lib').install Dir['bin/lib/*']
  end

  test do
    assert_match 'claude-team', shell_output("#{bin}/claude-team --help 2>&1")
  end
end
