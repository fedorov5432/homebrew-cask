cask 'libreoffice' do
  version '5.2.2'
  sha256 '73b501e710a51016f80c38f4104021114a35c578b68ad48ac7e237a36bd015a4'

  # documentfoundation.org was verified as official when first introduced to the cask
  url "https://download.documentfoundation.org/libreoffice/stable/#{version}/mac/x86_64/LibreOffice_#{version}_MacOS_x86-64.dmg"
  name 'LibreOffice'
  homepage 'https://www.libreoffice.org/'
  license :mpl
  gpg "#{url}.asc",
      key_id: 'c2839ecad9408fbe9531c3e9f434a1efafeeaea3'

  app 'LibreOffice.app'
  binary "#{appdir}/LibreOffice.app/Contents/MacOS/gengal"
  binary "#{appdir}/LibreOffice.app/Contents/MacOS/regmerge"
  binary "#{appdir}/LibreOffice.app/Contents/MacOS/regview"
  binary "#{appdir}/LibreOffice.app/Contents/MacOS/senddoc"
  binary "#{appdir}/LibreOffice.app/Contents/MacOS/ui-previewer"
  binary "#{appdir}/LibreOffice.app/Contents/MacOS/uno"
  binary "#{appdir}/LibreOffice.app/Contents/MacOS/unopkg"
  binary "#{appdir}/LibreOffice.app/Contents/MacOS/urelibs"
  binary "#{appdir}/LibreOffice.app/Contents/MacOS/uri-encode"
  binary "#{appdir}/LibreOffice.app/Contents/MacOS/xpdfimport"
  # shim script (https://github.com/caskroom/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/soffice.wrapper.sh"
  binary shimscript, target: 'soffice'

  preflight do
    IO.write shimscript, <<-EOS.undent
      #!/bin/sh
      '#{appdir}/LibreOffice.app/Contents/MacOS/soffice' "$@"
    EOS
    FileUtils.chmod '+x', shimscript
  end

  zap delete: [
                '~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.libreoffice.script.sfl',
                '~/Library/Application Support/LibreOffice',
              ]
end
