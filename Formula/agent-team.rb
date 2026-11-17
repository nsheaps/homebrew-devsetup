# typed: false
# frozen_string_literal: true

class AgentTeam < Formula
  desc 'Provider-agnostic agent team orchestration for Claude Code'
  homepage 'https://github.com/nsheaps/agent-team'
  url 'https://github.com/nsheaps/agent-team/archive/refs/tags/v0.3.191.tar.gz'
  sha256 '705a1cb501b5dfa12275ee8a3dcc84a2a8e9c004772f731fae2975830c0f7cc7'
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
