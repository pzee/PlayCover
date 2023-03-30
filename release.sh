#!/bin/sh
set -eu -o pipefail

xcodebuild clean archive -scheme PlayCover -configuration Release -archivePath build/PlayCover.xcarchive

APP_BUNDLE="build/PlayCover.xcarchive/Products/Applications/PlayCover.app"
codesign -s "Developer ID Application: Hao Guan (29V29Y67P2)" -f -o runtime --deep --timestamp $APP_BUNDLE/Contents/Frameworks/PlayTools.framework/PlugIns/AKInterface.bundle
codesign -s "Developer ID Application: Hao Guan (29V29Y67P2)" -f -o runtime --deep --timestamp $APP_BUNDLE/Contents/Frameworks/PlayTools.framework
codesign -s "Developer ID Application: Hao Guan (29V29Y67P2)" -f -o runtime --deep --timestamp $APP_BUNDLE/Contents/Frameworks/Sparkle.framework
codesign -s "Developer ID Application: Hao Guan (29V29Y67P2)" -f -o runtime --deep --timestamp $APP_BUNDLE

mkdir -p build/PlayCover
ln -sfh /Applications build/PlayCover/Applications
mv $APP_BUNDLE build/PlayCover
hdiutil create -srcfolder build/PlayCover -format UDBZ build/PlayCover.dmg

xcrun notarytool submit build/PlayCover.dmg --keychain-profile "HG_NOTARY_PWD" --wait
xcrun stapler staple build/PlayCover.dmg
mv build/PlayCover.dmg build/PlayCover-$(date -u +"%Y%m%dT%H%M%SZ").dmg
open build
