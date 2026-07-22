# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  url 'https://github.com/nsheaps/git-wt/archive/refs/tags/v0.6.37.tar.gz'
  sha256 '3dc87bb7b5f5a83ba06634c613a127ea75a457a06211408bd1f8a91c2157092c'
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
