# typed: false
# frozen_string_literal: true

class AgentTeam < Formula
  desc 'Provider-agnostic agent team orchestration for Claude Code'
  homepage 'https://github.com/nsheaps/agent-team'
  url 'https://github.com/nsheaps/agent-team/archive/refs/tags/v0.3.152.tar.gz'
  sha256 'f467480099aa1655d35b61cbfa2886e799ffa68ed614b3557633846ae69665fd'
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
