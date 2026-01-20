# typed: false
# frozen_string_literal: true

class WorktreeSwitcher < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  # URL and sha256 are updated automatically by git-wt CI on release
  url 'https://github.com/nsheaps/git-wt.git', branch: 'main'
  version '0.1.0'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/git-wt.git', branch: 'main'
  end

  depends_on 'gum'
  depends_on 'gh'
  depends_on 'jq'

  def install
    bin.install 'bin/worktree-switcher'
  end

  test do
    assert_match 'worktree-switcher', shell_output("#{bin}/worktree-switcher --help")
  end
end
