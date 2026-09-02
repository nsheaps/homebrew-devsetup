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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.286/claude-utils-darwin-arm64.tar.gz'
      sha256 'ddcc97ce518bff6564c9cad963bdee9f697248479ad40726e42d74f8937e47a0'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.286/claude-utils-darwin-amd64.tar.gz'
      sha256 '06e643b88072f74a3b1524ed329ec00842f88faab8fd3d5560017914baebaa88'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.286/claude-utils-linux-arm64.tar.gz'
      sha256 '567ae40576e319bd021a7177ba05c2641b8f97248bcab71db304293411438ec8'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.286/claude-utils-linux-amd64.tar.gz'
      sha256 '6eb197fdff20486cccaf3d1b9c502b8491421609e99dfc7fd7a63a907080b9c8'
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
