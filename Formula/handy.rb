# typed: false
# frozen_string_literal: true

class Handy < Formula
  desc 'Open source offline speech-to-text transcription app'
  homepage 'https://handy.computer'
  license 'MIT'

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/cjpais/Handy/releases/download/v0.7.12/Handy_0.7.12_aarch64.AppImage'
      sha256 '2e7be5b88aab3f900612fc83d9d451cde6ad9f52c632bba80aab8e5493efee72'
    else
      url 'https://github.com/cjpais/Handy/releases/download/v0.7.12/Handy_0.7.12_amd64.AppImage'
      sha256 '421f363ef644ad65a1011b3b673a061659505cab05eb71941aa1b9b5a4fe915f'
    end
  end

  depends_on :linux

  def install
    appimage = Dir['*.AppImage'].first
    bin.install appimage => 'handy'
    chmod 0o755, bin / 'handy'

    # Install GNOME keybinding setup script
    (libexec / 'setup-gnome-shortcut').write <<~BASH
      #!/usr/bin/env bash
      set -euo pipefail

      SHORTCUT_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/handy/"
      SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
      BINDING_SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
      BINDING="${1:-<Super>z}"

      if ! command -v gsettings &>/dev/null; then
        echo "gsettings not found — skipping GNOME shortcut setup."
        exit 0
      fi

      # Read current custom keybindings and append ours if not already present
      CURRENT=$(gsettings get "$SCHEMA" custom-keybindings 2>/dev/null || echo "@as []")
      if echo "$CURRENT" | grep -q "handy"; then
        echo "Handy shortcut already registered, updating binding to $BINDING..."
      else
        if [ "$CURRENT" = "@as []" ]; then
          NEW="['$SHORTCUT_PATH']"
        else
          NEW=$(echo "$CURRENT" | sed "s|]$|, '$SHORTCUT_PATH']|")
        fi
        gsettings set "$SCHEMA" custom-keybindings "$NEW"
      fi

      gsettings set "$BINDING_SCHEMA:$SHORTCUT_PATH" name "Toggle Handy Transcription"
      gsettings set "$BINDING_SCHEMA:$SHORTCUT_PATH" command "#{bin}/handy --toggle-transcription"
      gsettings set "$BINDING_SCHEMA:$SHORTCUT_PATH" binding "$BINDING"

      echo "GNOME shortcut bound: $BINDING → handy --toggle-transcription"
    BASH
    chmod 0o755, libexec / 'setup-gnome-shortcut'
  end

  def post_install
    return unless ENV['DISPLAY'] || ENV['WAYLAND_DISPLAY']

    system libexec / 'setup-gnome-shortcut'
  end

  def caveats
    <<~EOS
      Handy has been installed. To set up the GNOME keyboard shortcut:

        #{libexec}/setup-gnome-shortcut            # default: Super+Z
        #{libexec}/setup-gnome-shortcut '<Control>z'  # custom binding

      For Wayland text input, install wtype or dotool:
        sudo apt install wtype

      For X11 text input, install xdotool:
        sudo apt install xdotool
    EOS
  end

  test do
    assert_match 'toggle-transcription', shell_output("#{bin}/handy --help 2>&1", 1)
  end
end
