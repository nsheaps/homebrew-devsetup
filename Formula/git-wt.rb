# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/git-wt'
  url 'https://github.com/nsheaps/git-wt/archive/refs/tags/v0.4.2.tar.gz'
  sha256 '4d2c95315f103de19d5b557337207e9fc841e0e4f008b0edebea2b1fcc2ccd97'
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
