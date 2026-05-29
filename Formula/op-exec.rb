# typed: false
# frozen_string_literal: true

class OpExec < Formula
  desc 'Execute commands with 1Password secrets as environment variables'
  homepage 'https://github.com/nsheaps/op-exec'
  url 'https://github.com/nsheaps/op-exec/archive/refs/tags/v0.1.10.tar.gz'
  sha256 'c344bb18edda64d0ecb9569b210733a80de3e624aefd3aaa10cb55280e6e608f'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/op-exec.git', branch: 'main'
  end

  depends_on '1password-cli'

  def install
    bin.install Dir['bin/*']
  end

  test do
    assert_match 'op-exec', shell_output("#{bin}/op-exec --help")
  end
end
