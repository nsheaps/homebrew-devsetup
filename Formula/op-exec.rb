# typed: false
# frozen_string_literal: true

class OpExec < Formula
  desc 'Execute commands with 1Password secrets as environment variables'
  homepage 'https://github.com/nsheaps/op-exec'
  url 'https://github.com/nsheaps/op-exec/archive/refs/tags/v0.0.1.tar.gz'
  sha256 '20449eeb299c7f41916c870278596d264016b961efbbb103508d08ad832758c7'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/op-exec.git', branch: 'main'
  end

  depends_on 'nsheaps/devsetup/onepassword-cli'

  def install
    bin.install Dir['bin/*']
  end

  test do
    assert_match 'op-exec', shell_output("#{bin}/op-exec --help")
  end
end
