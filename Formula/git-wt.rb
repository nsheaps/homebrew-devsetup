# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  url 'https://github.com/nsheaps/git-wt/archive/refs/tags/v0.6.71.tar.gz'
  sha256 '1189a709dab37b0eb4eb597219733a2013fa4a2c5dcfe0572a3f57103523b4d2'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/git-wt.git', branch: 'main'
  end

  depends_on 'gum'

  def install
    bin.install 'bin/git-wt'
  end

  test do
    assert_match 'git-wt', shell_output("#{bin}/git-wt --help")
  end
end
