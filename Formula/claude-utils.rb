# typed: false
# frozen_string_literal: true

class ClaudeUtils < Formula
  desc 'CLI utilities for Claude Code workflow management'
  homepage 'https://github.com/nsheaps/claude-utils'
  license 'MIT'

  # agent-plugin and agent-hook are native, self-contained binaries produced by
  # `bun build --compile` and shipped per-platform in the release tarballs. Everything
  # else in bin/ is platform-independent bash. No node/bun is needed at runtime.
  on_macos do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.297/claude-utils-darwin-arm64.tar.gz'
      sha256 '045a272d4ac7478069d0a889b417a6149b347dece7fbcee28650b62a989610fc'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.297/claude-utils-darwin-amd64.tar.gz'
      sha256 '4c2f07f894fdce31d5ed3bc4b223e154fb5f79e97f08b8d4d91a841b5c83ae94'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.297/claude-utils-linux-arm64.tar.gz'
      sha256 'e97df78fb2f13e64faf39798a779d24c861da634d56100b170879f9c002ca244'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.297/claude-utils-linux-amd64.tar.gz'
      sha256 '02f75af4f5eae25510d351fb43ff5d2b712a340d8ec2f6e3929565e6de2f3250'
    end
  end

  depends_on 'fzf'
  depends_on 'gum'

  def install
    # The release tarball wraps its payload in a single top-level dist/ directory. Homebrew strips
    # that lone leading directory and chdir's into it, so by the time this runs the working
    # directory is dist/. Install only dist/bin/ into #{bin} (lib/ lands at #{bin}/lib, where the
    # bash CLIs source it via $SCRIPT_DIR). Wrapping in dist/ means future non-bin payloads can be
    # shipped under dist/ (e.g. dist/share, dist/man) without being swept into #{bin}.
    bin.install Dir['bin/*']
  end

  test do
    assert_match 'ccresume', shell_output("#{bin}/ccresume --help 2>&1", 1)
    assert_match 'Usage: agent-plugin', shell_output("#{bin}/agent-plugin --help")
    assert_match 'Usage: agent-hook', shell_output("#{bin}/agent-hook --help")
  end
end
