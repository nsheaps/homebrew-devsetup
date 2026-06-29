# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  url 'https://github.com/nsheaps/git-wt/archive/refs/tags/v0.6.32.tar.gz'
  sha256 'dc6235f98aac98c60bae6b4645a66744d55c1025e9dfc7bd22cf90c80a706a5d'
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
