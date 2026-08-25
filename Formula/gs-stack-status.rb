# typed: false
# frozen_string_literal: true

class GsStackStatus < Formula
  desc 'Terminal dashboard for git-spice stacked branch workflows'
  homepage 'https://github.com/nsheaps/gs-stack-status'
  url 'https://github.com/nsheaps/gs-stack-status/archive/refs/tags/v0.3.12.tar.gz'
  sha256 '008466b72711a80b31ac454da727d1d346ea5173d597632a7e6866a5b1fd8f44'
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
