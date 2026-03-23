cask 'handy' do
  version '0.7.12'

  on_arm do
    url "https://github.com/cjpais/Handy/releases/download/v#{version}/Handy_#{version}_aarch64.dmg"
    sha256 'd7acf62e4c8ca91100d0759d1b7fe5bc3d425352c2e2dfe68ca734166675622d'
  end

  on_intel do
    url "https://github.com/cjpais/Handy/releases/download/v#{version}/Handy_#{version}_x64.dmg"
    sha256 'dc3628cf83405cb25cadcd1f091581f50603fdc7b7adbe2eb911a3a72196e0a1'
  end

  name 'Handy'
  desc 'Open source offline speech-to-text transcription app'
  homepage 'https://handy.computer'

  livecheck do
    url 'https://github.com/cjpais/Handy/releases/latest'
    strategy :header_match
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
