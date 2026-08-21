# typed: false
# frozen_string_literal: true

class GsStackStatus < Formula
  desc 'Terminal dashboard for git-spice stacked branch workflows'
  homepage 'https://github.com/nsheaps/gs-stack-status'
  url 'https://github.com/nsheaps/gs-stack-status/archive/refs/tags/v0.3.11.tar.gz'
  sha256 '52a2cc76605476fcf35e12ddd10f6ef7c5ccc3c1856eb8cb0f78cce0715e36fa'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/gs-stack-status.git', branch: 'main'
  end

  depends_on 'git-spice'
  depends_on 'gum'

  def install
    bin.install Dir['bin/*']
  end

  test do
    assert_match 'gs-stack-status', shell_output("#{bin}/gs-stack-status --help 2>&1")
  end
end
