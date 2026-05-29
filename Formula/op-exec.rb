# typed: false
# frozen_string_literal: true

class OpExec < Formula
  desc 'Execute commands with 1Password secrets as environment variables'
  homepage 'https://github.com/nsheaps/op-exec'
  url 'https://github.com/nsheaps/op-exec/archive/refs/tags/v0.1.11.tar.gz'
  sha256 '5aa00aa9fb48fd8696a4235b8154e49bd660958c82dc5fdaae7ee95b30310c59'
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
