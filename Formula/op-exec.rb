# typed: false
# frozen_string_literal: true

class OpExec < Formula
  desc 'Execute commands with 1Password secrets as environment variables'
  homepage 'https://github.com/nsheaps/op-exec'
  url 'https://github.com/nsheaps/op-exec/archive/refs/tags/v0.1.29.tar.gz'
  sha256 '9e1ce04640931bce3b6674500296fb1b6a68b3084114f50cc77d65c1ca77309d'
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
