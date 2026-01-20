# typed: false
# frozen_string_literal: true

class WorktreeSwitcher < Formula
  desc 'Interactive TUI for git worktree management'
  homepage 'https://github.com/nsheaps/homebrew-devsetup'
  url 'https://raw.githubusercontent.com/nsheaps/homebrew-devsetup/v1.0.0/bin/worktree-switcher'
  sha256 'PLACEHOLDER'
  version '1.0.0'
  license 'MIT'

  # For development/HEAD installs, use the repo directly
  head do
    url 'https://github.com/nsheaps/homebrew-devsetup.git', branch: 'main'
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
