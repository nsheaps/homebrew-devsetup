# typed: false
# frozen_string_literal: true

class WorktreeSwitcher < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  url 'https://github.com/nsheaps/git-wt/releases/download/v0.2.4/worktree-switcher'
  sha256 '0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5'
  version '0.2.4'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/git-wt.git', branch: 'main'
  end

  depends_on 'gum'
  depends_on 'gh'
  depends_on 'jq'

  def install
    if build.head?
      bin.install 'bin/worktree-switcher'
    else
      bin.install 'worktree-switcher'
    end
  end

  test do
    assert_match 'worktree-switcher', shell_output("#{bin}/worktree-switcher --help")
  end
end
