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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.303/claude-utils-darwin-arm64.tar.gz'
      sha256 '606844f7afb3c4a1e5cbd07f7c810548e49aec001f9a61401c189fcbdb8726f1'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.303/claude-utils-darwin-amd64.tar.gz'
      sha256 '5717f8804a250b97af32b87a8660a91d8fdc9a55b0fbe126160af860336dd224'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.303/claude-utils-linux-arm64.tar.gz'
      sha256 'e607f3f918c910d400c0fb0c82bb956ebd907d7a4ea445a8247a43d2798c8db6'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.303/claude-utils-linux-amd64.tar.gz'
      sha256 '2393e800b75fa3808a62397f809e169c25e4483555ccc930ad020e00c774248d'
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
