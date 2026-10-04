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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.324/claude-utils-darwin-arm64.tar.gz'
      sha256 'e3cf282b65eb90824efdd5edbc4ccb979898ef9dbcbc488e5cae2fa6c9d64fbc'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.324/claude-utils-darwin-amd64.tar.gz'
      sha256 '41f6dd5f0e85972cb1357c27abfaadfae216e40c68a320985abe7d9cc50ce643'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.324/claude-utils-linux-arm64.tar.gz'
      sha256 '898778152b77c8cd50bf2ad34e13f30919bf18258bec437803f26f0f7482725c'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.324/claude-utils-linux-amd64.tar.gz'
      sha256 '266ed9cffb96b6cd8f0e07afd9d0e27974472094f0caf22a42a3d9ded25a4c73'
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
