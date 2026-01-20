# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc "Interactive TUI for git worktree management"
  homepage "https://github.com/nsheaps/git-wt"
  url "https://github.com/nsheaps/git-wt/releases/download/v0.3.0/git-wt"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  version "0.3.0"
  license "MIT"

  head do
    url "https://github.com/nsheaps/git-wt.git", branch: "main"
  end

  depends_on "gum"

  def install
    if build.head?
      bin.install "bin/git-wt"
    else
      bin.install "git-wt"
    end
  end

  test do
    assert_match "git-wt", shell_output("#{bin}/git-wt --help")
  end
end
