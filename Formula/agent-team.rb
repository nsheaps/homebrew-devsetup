# typed: false
# frozen_string_literal: true

class AgentTeam < Formula
  desc 'Provider-agnostic agent team orchestration for Claude Code'
  homepage 'https://github.com/nsheaps/agent-team'
  url 'https://github.com/nsheaps/agent-team/archive/refs/tags/v0.3.132.tar.gz'
  sha256 '0405b96c9054c078c78173fc814aa6b6a732f70cb04d3b1d9c1fd3d1b9a786dc'
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
