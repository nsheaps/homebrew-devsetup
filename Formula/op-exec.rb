# typed: false
# frozen_string_literal: true

class OpExec < Formula
  desc 'Execute commands with 1Password secrets as environment variables'
  homepage 'https://github.com/nsheaps/op-exec'
  url 'https://github.com/nsheaps/op-exec/archive/refs/tags/v0.1.38.tar.gz'
  sha256 'f86103483f1f580a4e56a70e7ad4a180c65f9c8e13f082aa0c541bd91b458ea8'
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
