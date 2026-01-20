# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  url 'https://github.com/nsheaps/git-wt/releases/download/v0.4.0/git-wt'
  sha256 '4d7ba9eae91c915b1463a8173fb75ddfb39b4d0cfe138b5782d417dab5ac9d0a'
  version '0.4.0'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/git-wt.git', branch: 'main'
  end

  depends_on 'gum'

  def install
    if build.head?
      bin.install 'bin/git-wt'
    else
      bin.install 'git-wt'
    end
  end

  test do
    assert_match 'git-wt', shell_output("#{bin}/git-wt --help")
  end
end
