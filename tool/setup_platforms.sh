#!/usr/bin/env bash
set -e
if [ ! -d "android" ] || [ ! -d "ios" ]; then
  TMPDIR=$(mktemp -d)
  flutter create --org com.healingbowl --project-name healing_bowl_tuner "$TMPDIR/app"
  [ ! -d "android" ] && mv "$TMPDIR/app/android" ./android
  [ ! -d "ios" ] && mv "$TMPDIR/app/ios" ./ios
  rm -rf "$TMPDIR"
fi
mkdir -p android/app/src/main/kotlin/com/healingbowl/tuner/
cp -f android_patches/MainActivity.kt android/app/src/main/kotlin/com/healingbowl/tuner/MainActivity.kt || true
cp -f android_patches/AndroidManifest.xml android/app/src/main/AndroidManifest.xml || true
cp -f android_patches/build.gradle android/app/build.gradle || true
cp -f ios_patches/AppDelegate.swift ios/Runner/AppDelegate.swift || true
cp -f ios_patches/AudioEngine.swift ios/Runner/AudioEngine.swift || true
cp -f ios_patches/Info.plist ios/Runner/Info.plist || true
echo Done
