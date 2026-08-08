# typed: false
# frozen_string_literal: true

require 'language/node'

class ClaudeUtils < Formula
  desc 'CLI utilities for Claude Code workflow management'
  homepage 'https://github.com/nsheaps/claude-utils'
  url 'https://github.com/nsheaps/claude-utils/archive/refs/tags/v0.12.242.tar.gz'
  sha256 'd023e5a430228b0b91491e0ae5720ce7ce38f838b02023393c361171e9ad54a9'
  license 'MIT'

  head do
    url 'https://github.com/nsheaps/claude-utils.git', branch: 'main'
  end

  depends_on 'fzf'
  depends_on 'gum'
  # agent-plugin and agent-hook are single-file node programs. Everything else in bin/ is bash.
  depends_on 'node'

  # The node CLIs in bin/ are committed build output, bundled by scripts/build-cli.mjs with every
  # dependency inlined, so nothing is compiled or fetched here — the tarball already holds runnable
  # files. That is why node is the only addition and there is no yarn/npm install step.
  NODE_CLIS = %w[agent-plugin agent-hook].freeze

  def install
    bin.install Dir['bin/*']

    # Rewrite `#!/usr/bin/env node` to this node's absolute path.
    #
    # `env node` resolves through PATH at run time, and these CLIs are called from hooks and plugin
    # scripts whose PATH is whatever the harness happened to hand them. depends_on 'node' guarantees
    # node is INSTALLED, not that it is on that PATH, so the env form can fail with a bare
    # "env: node: No such file or directory" in exactly the context these tools are built for.
    # Pinning the interpreter here removes the run-time lookup entirely. The source keeps the env
    # form so the same file still runs straight out of a git checkout.
    rewrite_shebang detected_node_shebang, *NODE_CLIS.map { |cli| bin/cli }
  end

  test do
    assert_match 'ccresume', shell_output("#{bin}/ccresume --help 2>&1", 1)

    # Each node CLI actually starts and prints its usage. This is the check that catches a bad
    # shebang rewrite or a bundle that cannot load, which a plain file-exists test would not.
    assert_match 'Usage: agent-plugin', shell_output("#{bin}/agent-plugin --help")
    assert_match 'Usage: agent-hook', shell_output("#{bin}/agent-hook --help")

    # And that they do their actual job, not just print help. Each result goes through a local so
    # there are no continuation lines aligned under an argument: that alignment is not a multiple
    # of the indent width, which editorconfig-checker rejects.
    halt_json = shell_output("#{bin}/agent-hook halt 'formula smoke test'")
    assert_match '"continue":false', halt_json

    exports = shell_output("#{bin}/agent-hook export-input '{\"hook_event_name\":\"Stop\"}'")
    assert_match 'HOOK_EVENT_NAME', exports

    log_line = shell_output("#{bin}/agent-plugin --plugin smoke log hello 2>&1")
    assert_match 'INFO [smoke] hello', log_line
  end
end
