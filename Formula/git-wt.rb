# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  url 'https://github.com/nsheaps/git-wt/archive/refs/tags/v0.6.14.tar.gz'
  sha256 '353fe140776b339ed71d7ab261e2901ce1edb525d90b3261acd38915b8c145d9'
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
