cask 'handy' do
  version '0.7.12'

  name 'Handy'
  desc 'Open source offline speech-to-text transcription app'
  homepage 'https://handy.computer'

  livecheck do
    url 'https://github.com/cjpais/Handy/releases/latest'
    strategy :header_match
  end

  on_macos do
    on_arm do
      url "https://github.com/cjpais/Handy/releases/download/v#{version}/Handy_#{version}_aarch64.dmg"
      sha256 'd7acf62e4c8ca91100d0759d1b7fe5bc3d425352c2e2dfe68ca734166675622d'
    end

    on_intel do
      url "https://github.com/cjpais/Handy/releases/download/v#{version}/Handy_#{version}_x64.dmg"
      sha256 'dc3628cf83405cb25cadcd1f091581f50603fdc7b7adbe2eb911a3a72196e0a1'
    end

    app 'Handy.app'

    zap trash: [
      '~/Library/Application Support/computer.handy',
      '~/Library/Caches/computer.handy',
      '~/Library/Preferences/computer.handy.plist'
    ]

    caveats <<~EOS
      Handy registers its own global keyboard shortcut for push-to-talk.
      Configure the shortcut in the Handy app preferences after first launch.
    EOS
  end

  on_linux do
    on_arm do
      url "https://github.com/cjpais/Handy/releases/download/v#{version}/Handy_#{version}_aarch64.AppImage"
      sha256 '2e7be5b88aab3f900612fc83d9d451cde6ad9f52c632bba80aab8e5493efee72'

      binary "Handy_#{version}_aarch64.AppImage", target: 'handy'
    end

    on_intel do
      url "https://github.com/cjpais/Handy/releases/download/v#{version}/Handy_#{version}_amd64.AppImage"
      sha256 '421f363ef644ad65a1011b3b673a061659505cab05eb71941aa1b9b5a4fe915f'

      binary "Handy_#{version}_amd64.AppImage", target: 'handy'
    end

    caveats <<~EOS
      To set up a GNOME keyboard shortcut for Handy (Super+Z):

        SHORTCUT_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/handy/"
        SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
        BINDING_SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
        CURRENT=$(gsettings get "$SCHEMA" custom-keybindings)
        [ "$CURRENT" = "@as []" ] && NEW="['$SHORTCUT_PATH']" || NEW=$(echo "$CURRENT" | sed "s|]$|, '$SHORTCUT_PATH']|")
        gsettings set "$SCHEMA" custom-keybindings "$NEW"
        gsettings set "$BINDING_SCHEMA:$SHORTCUT_PATH" name "Toggle Handy Transcription"
        gsettings set "$BINDING_SCHEMA:$SHORTCUT_PATH" command "#{HOMEBREW_PREFIX}/bin/handy --toggle-transcription"
        gsettings set "$BINDING_SCHEMA:$SHORTCUT_PATH" binding "<Super>z"

      For Wayland text input, install wtype or dotool:
        sudo apt install wtype

      For X11 text input, install xdotool:
        sudo apt install xdotool
    EOS
  end
end
