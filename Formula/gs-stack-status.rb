# typed: false
# frozen_string_literal: true

class GsStackStatus < Formula
  desc 'Terminal dashboard for git-spice stacked branch workflows'
  homepage 'https://github.com/nsheaps/gs-stack-status'
  url 'https://github.com/nsheaps/gs-stack-status/archive/refs/tags/v0.3.10.tar.gz'
  sha256 '1268b85449cc4727b6491893db6d433f946b6bc70a7b248e31d95413f97d2e83'
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
