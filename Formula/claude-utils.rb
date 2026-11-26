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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.391/claude-utils-darwin-arm64.tar.gz'
      sha256 '284bea809cbec3e811cab4ce40196b4124407bdb27ceeb9d434f1a4a9d341ec8'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.391/claude-utils-darwin-amd64.tar.gz'
      sha256 '7cdb973fa6cee28dce37b29f322bd1f19a373e8144e62bf99fb319cc24d05883'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.391/claude-utils-linux-arm64.tar.gz'
      sha256 '2315f0fcaf60e359384e132a0144ad1811e958185ae18d75f6c25ffda832c876'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.391/claude-utils-linux-amd64.tar.gz'
      sha256 '158e60e32a29121e84ad1bc26d13b670fc3382073cb600c829680a636634841a'
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
