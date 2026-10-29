# typed: false
# frozen_string_literal: true

class GsStackStatus < Formula
  desc 'Terminal dashboard for git-spice stacked branch workflows'
  homepage 'https://github.com/nsheaps/gs-stack-status'
  url 'https://github.com/nsheaps/gs-stack-status/archive/refs/tags/v0.3.26.tar.gz'
  sha256 'b7b539858d84c3f19e838836ee15b1f52703231cb3355b80a9d672d2e464a788'
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
