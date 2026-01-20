# typed: false
# frozen_string_literal: true

class GitWt < Formula
  desc "Interactive TUI for git worktree management"
  homepage "https://github.com/nsheaps/git-wt"
  url "https://github.com/nsheaps/git-wt/releases/download/v0.3.2/git-wt"
  sha256 "7a772d0bc12f88d183cd8bfb869d5c50c016de12761f966a7f460b33f3de755d"
  version "0.3.2"
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
