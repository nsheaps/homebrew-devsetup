# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  url 'https://github.com/nsheaps/git-wt/releases/download/v0.3.0/git-wt'
  sha256 'fe820f8f929b9c05bc6647ea1232290d0bf6b10e1ee4a2c7e244e70b571f309d'
  version '0.3.0'
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
