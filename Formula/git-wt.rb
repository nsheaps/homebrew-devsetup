# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  url 'https://github.com/nsheaps/git-wt/archive/refs/tags/v0.4.0.tar.gz'
  sha256 '44bbaddbed4b2918c0879488de5d9fb51477c4b165bbbb3f74b2f2ac92ba6c93'
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
