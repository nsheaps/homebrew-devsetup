# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  url 'https://github.com/nsheaps/git-wt/archive/refs/tags/v0.3.2.tar.gz'
  sha256 '379639fe2ae1436cce3351dcd42ebfa1598e2e0378ccfab43644671d0dd1475f'
  version '0.3.1'
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
