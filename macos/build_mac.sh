#!/bin/bash
# Builds TeamPulse.app and TeamPulse-prototype.dmg from the prototype site.
#
#   bash macos/build_mac.sh
#
# Needs only Apple's Command Line Tools (clang, codesign, hdiutil, iconutil). No downloads.
# Output goes to macos/dist/ (ignored by git).

set -euo pipefail
cd "$(dirname "$0")"

APP="dist/TeamPulse.app"
VERSION="0.1.0"
FLAGS=(-fobjc-arc -O2 -mmacosx-version-min=12.0 -Wno-deprecated-declarations)

echo "1/7 Building the site..."
python3 ../scripts/build_site.py > /dev/null

rm -rf build dist
mkdir -p build dist

echo "2/7 Compiling the app..."
# One app for Intel and Apple Silicon Macs. If the universal build fails, build for this Mac only.
if clang "${FLAGS[@]}" -arch x86_64 -arch arm64 -framework Cocoa -framework WebKit main.m -o build/TeamPulse 2> build/universal.log; then
  :
else
  echo "    universal build failed, building for this Mac only ($(uname -m))"
  clang "${FLAGS[@]}" -arch "$(uname -m)" -framework Cocoa -framework WebKit main.m -o build/TeamPulse
fi

echo "3/7 Drawing the icon..."
clang -fobjc-arc -framework Cocoa make_icon.m -o build/make_icon
build/make_icon build/AppIcon.iconset > /dev/null
iconutil -c icns build/AppIcon.iconset -o build/AppIcon.icns

echo "4/7 Assembling the app..."
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp build/TeamPulse "$APP/Contents/MacOS/TeamPulse"
cp build/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
cp selftest.js "$APP/Contents/Resources/selftest.js"
cp -R ../site "$APP/Contents/Resources/site"
rm -f "$APP/Contents/Resources/site/vercel.json"
rm -rf "$APP/Contents/Resources/site/downloads"
cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>TeamPulse</string>
  <key>CFBundleDisplayName</key><string>TeamPulse</string>
  <key>CFBundleIdentifier</key><string>com.teampulse.prototype</string>
  <key>CFBundleExecutable</key><string>TeamPulse</string>
  <key>CFBundleIconFile</key><string>AppIcon</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>${VERSION}</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>12.0</string>
  <key>NSHighResolutionCapable</key><true/>
  <key>LSApplicationCategoryType</key><string>public.app-category.business</string>
  <key>NSHumanReadableCopyright</key><string>TeamPulse prototype. Your data stays on this computer.</string>
</dict>
</plist>
PLIST

echo "5/7 Signing (ad hoc, for this Mac)..."
codesign --force --deep --sign - "$APP" 2> /dev/null
codesign --verify --deep --strict "$APP"

echo "6/7 Packaging the installer..."
mkdir -p dist/dmgroot
cp -R "$APP" dist/dmgroot/
ln -s /Applications dist/dmgroot/Applications
hdiutil create -volname "TeamPulse" -srcfolder dist/dmgroot -ov -format UDZO dist/TeamPulse-prototype.dmg > /dev/null
rm -rf dist/dmgroot

echo "7/7 Zipping the download for the website..."
ZIPSTAGE="dist/zipstage/TeamPulse for Mac"
mkdir -p "$ZIPSTAGE" ../site/downloads
cp -R "$APP" "$ZIPSTAGE/"
cat > "$ZIPSTAGE/READ ME FIRST.txt" <<'TXT'
TeamPulse for Mac
=================

TeamPulse opens in its own window, like any other app. Your data stays on this Mac.
Works on macOS 12 or newer, on Intel and Apple Silicon Macs.

To install
1. Drag TeamPulse into your Applications folder.
2. Open TeamPulse from Applications or Launchpad.

If your Mac says it cannot check the app
This app is not from the App Store yet, so macOS asks before it opens it the first time.
- macOS 15: open System Settings, then Privacy & Security. Scroll down to the message about
  TeamPulse and choose "Open Anyway".
- macOS 14 or older: Control-click TeamPulse and choose Open, then Open again.
You only do this once.
TXT
rm -f ../site/downloads/TeamPulse-mac.zip
ditto -c -k --sequesterRsrc --keepParent "$ZIPSTAGE" "$(cd ../site/downloads && pwd)/TeamPulse-mac.zip"
rm -rf dist/zipstage

echo
echo "Built:"
echo "  $(pwd)/$APP  ($(lipo -archs "$APP/Contents/MacOS/TeamPulse"), $(du -sh "$APP" | cut -f1))"
echo "  $(pwd)/dist/TeamPulse-prototype.dmg  ($(du -sh dist/TeamPulse-prototype.dmg | cut -f1))"
echo "  $(cd ../site/downloads && pwd)/TeamPulse-mac.zip  ($(du -sh ../site/downloads/TeamPulse-mac.zip | cut -f1))"
