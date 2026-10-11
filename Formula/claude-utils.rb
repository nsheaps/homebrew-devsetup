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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.335/claude-utils-darwin-arm64.tar.gz'
      sha256 '95996e6d569d982388f9acfcc691af8c402b665b6a45164811af5f9e123104a5'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.335/claude-utils-darwin-amd64.tar.gz'
      sha256 '0d4c1c83854fd891a88e5c9b4e892bdd13f458d2bae715d1e6f675a2f8969db1'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.335/claude-utils-linux-arm64.tar.gz'
      sha256 '5297322d525f9839166281fe244101cf62a37c280f9c86933ba25e328fc3c381'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.335/claude-utils-linux-amd64.tar.gz'
      sha256 '9984e186d4156793a2ee36c641fee61ccc6568659a9e223a3d97927aaab30a7c'
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
