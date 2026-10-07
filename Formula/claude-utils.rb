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
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.329/claude-utils-darwin-arm64.tar.gz'
      sha256 '29398dc256e5726660a665244840ab07101c89504b77130c1609b6601d17b818'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.329/claude-utils-darwin-amd64.tar.gz'
      sha256 '77c313672e994f614ef5e89b585ada2de12066efcf7420253b7a5460f39ceba2'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.329/claude-utils-linux-arm64.tar.gz'
      sha256 'd403ff01c55bc5d1fb349f8b2a77870f4a3fbca63489981fc49d024ebdc0f4a0'
    else
      url 'https://github.com/nsheaps/claude-utils/releases/download/v0.12.329/claude-utils-linux-amd64.tar.gz'
      sha256 '91cad808e59dfee5ad21c9d596bbdf03ffe32068cf72300c1fc648661efe1640'
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
