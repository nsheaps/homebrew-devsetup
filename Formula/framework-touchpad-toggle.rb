class FrameworkTouchpadToggle < Formula
  desc 'Toggle the Framework laptop internal touchpad on Linux (GNOME X11/Wayland)'
  homepage 'https://github.com/nsheaps/framework-touchpad-toggle'
  url 'https://github.com/nsheaps/framework-touchpad-toggle/archive/refs/tags/v0.0.5.tar.gz'
  sha256 '370d9d03bd5c40d47d637e46874321180ecb8d3789e48f445c21625df6463a49'
  license 'MIT'
  head 'https://github.com/nsheaps/framework-touchpad-toggle.git', branch: 'main'

  # Interactive prompting during `install` is deliberate here and is against
  # Homebrew best practices (see INIT.md / CLAUDE.md). It is gated so that
  # unattended installs (CI, NONINTERACTIVE=1, or all `--with-*` options
  # supplied) never block. Do NOT submit this formula to homebrew-core.

  option 'with-shortcut', 'Register the GNOME keyboard shortcut during install (default)'
  option 'without-shortcut', 'Do not register the keyboard shortcut during install'
  option 'with-unattended', 'Skip all prompts; use option/env values and defaults'

  depends_on 'bash'

  on_macos do
    # Framework laptops do not run macOS — hard fail, this can never work.
    def caveats
      odie 'framework-touchpad-toggle is Linux-only; Framework laptops do not run macOS.'
    end
  end

  on_linux do
    depends_on 'xdotool' => :recommended # xinput lives in the X11 utils; see caveats
  end

  def install
    odie 'framework-touchpad-toggle is Linux-only.' if OS.mac?

    # Library helpers under libexec; the entrypoint is wrapped so it can
    # find them regardless of how Homebrew links it.
    libexec.install Dir['lib/*']
    (libexec / 'framework-touchpad-toggle').install 'bin/framework-touchpad-toggle'

    # share assets (desktop + systemd templates) for reference / manual use
    pkgshare.install 'share/desktop/framework-touchpad-toggle.desktop'
    pkgshare.install 'share/systemd/framework-touchpad-toggle.service'

    (bin / 'framework-touchpad-toggle').write <<~SH
      #!/usr/bin/env bash
      export FTT_LIBDIR="#{libexec}"
      exec "#{libexec}/framework-touchpad-toggle" "$@"
    SH
    chmod 0o755, bin / 'framework-touchpad-toggle'
  end

  def post_install
    return if OS.mac?

    # Soft, non-fatal warnings — keeps `brew install` working in CI and on
    # non-Framework Linux boxes. The runtime script fails hard when actually
    # invoked on an unsupported configuration.
    opoo 'Not a Debian-based distro; framework-touchpad-toggle is untested here.' unless debian_like?
    opoo 'This does not look like a Framework laptop; behavior is untested.' unless framework_hardware?

    # Decide interactivity. Unattended when: --with-unattended, Homebrew's
    # own NONINTERACTIVE mode, or no controlling TTY.
    unattended = build.with?('unattended') ||
      ENV['NONINTERACTIVE'].present? ||
      !$stdin.tty?

    args = ['configure']
    args << '--preserve' if unattended

    flags = []
    flags << "FTT_OPT_INSTALL_SHORTCUT=#{build.without?('shortcut') ? 'false' : 'true'}"

    ohai 'Configuring framework-touchpad-toggle'
    system(*flags, bin / 'framework-touchpad-toggle', *args)
  rescue StandardError => e
    # Never let configuration failure abort the package installation;
    # the user can re-run `framework-touchpad-toggle configure`.
    opoo "Configuration step did not complete: #{e.message}"
    opoo 'Run it manually: framework-touchpad-toggle configure'
  end

  def caveats
    <<~EOS
      framework-touchpad-toggle is configured per-user. If install-time
      configuration was skipped, run:

        framework-touchpad-toggle configure

      Config file (shared across versions, never overwritten on upgrade):
        ${XDG_CONFIG_HOME:-~/.config}/framework-touchpad-toggle/config.ini

      X11 sessions require the `xinput` utility (package: x11-xserver-utils
      on Debian/Ubuntu). Wayland uses GNOME gsettings and needs no extra
      package, but cannot target a single touchpad device.

      Reference assets installed under:
        #{opt_pkgshare}
    EOS
  end

  def debian_like?
    File.exist?('/etc/debian_version') ||
      (File.exist?('/etc/os-release') &&
        File.read('/etc/os-release').match?(/^ID(_LIKE)?=.*debian/m))
  end

  def framework_hardware?
    path = '/sys/class/dmi/id/sys_vendor'
    File.exist?(path) && File.read(path).strip == 'Framework'
  end

  test do
    assert_match "framework-touchpad-toggle #{version}",
      shell_output("#{bin}/framework-touchpad-toggle --version")
    assert_match 'Usage:', shell_output("#{bin}/framework-touchpad-toggle help")
    assert_match 'config.ini', shell_output("#{bin}/framework-touchpad-toggle config-path")
  end
end
