# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  url 'https://github.com/nsheaps/git-wt/archive/refs/tags/v0.6.62.tar.gz'
  sha256 '297831f76a95404ace51eace9b76024aaf732e2aff3c45aac214b37220ac6a39'
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
