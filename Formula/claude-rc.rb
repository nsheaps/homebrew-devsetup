# typed: false
# frozen_string_literal: true

class ClaudeRc < Formula
  desc 'Keep Claude Code remote-control sessions running for your repos'
  homepage 'https://github.com/nsheaps/agents'
  version '0.1.0'
  license 'MIT'

  on_macos do
    on_arm do
      url 'https://github.com/nsheaps/agents/archive/refs/tags/v0.3.169.tar.gz'
      sha256 'f695634549c27ced7475fa33870d341a29ceec1a90e40d80dd021d7563d296d8'
    end
    on_intel do
      url 'https://github.com/nsheaps/agents/releases/download/claude-rc-v0.1.0/claude-rc-0.1.0-darwin-x64.tar.gz'
      sha256 '3f916e334be9d98dfa620e4c74dc18e34e6b69010acf32dde3db16d216cb806a'
    end
  end

  on_linux do
    on_arm do
      url 'https://github.com/nsheaps/agents/releases/download/claude-rc-v0.1.0/claude-rc-0.1.0-linux-arm64.tar.gz'
      sha256 '5d7f44940763b41c14dd13d56263b4f464f47a00b7d59d7bdcd2078fb536eaa2'
    end
    on_intel do
      url 'https://github.com/nsheaps/agents/releases/download/claude-rc-v0.1.0/claude-rc-0.1.0-linux-x64.tar.gz'
      sha256 '0c686fb2b037f53e3b88a46f01dfe7b23eeb06d44d9f86dcf581065d60ce6b1c'
    end
  end

  # Each repo's `claude rc` runs in a private tmux session you can attach to.
  depends_on 'tmux'

  def install
    bin.install 'claude-rc'
    bin.install 'claude-rc-daemon'
  end

  # `brew services start claude-rc` runs the daemon at login/boot. The daemon
  # supervises one `claude rc` service per repo in ~/.claude/daemon/rc.json.
  service do
    run [opt_bin/'claude-rc-daemon']
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/'log/claude-rc-daemon.log'
    error_log_path var/'log/claude-rc-daemon.log'
  end

  def caveats
    <<~EOS
      Create ~/.claude/daemon/rc.json, e.g.:

        {"repos":[{"name":"my-repo","path":"/abs/path/to/my-repo"}],"spawn":"worktree"}

      then start the daemon:

        brew services start claude-rc
        claude-rc status

      Open the settings/monitor page (with an in-browser terminal) with:  claude-rc ui
      Connect to a running session in your terminal with:  claude-rc attach <repo>
        (detach with Ctrl-b d; it keeps running)

      `claude` (Claude Code) must be installed and on your PATH.
      Linux desktop notifications need notify-send (libnotify).
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-rc --version")
    assert_match version.to_s, shell_output("#{bin}/claude-rc-daemon --version")
  end
end
