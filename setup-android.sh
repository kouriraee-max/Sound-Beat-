#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# Flat upload layout -> expected project layout
mkdir -p www/assets android-overlay/java
[ -f index.html ] && cp index.html www/index.html
[ -f icon.png ] && cp icon.png www/assets/icon.png
cp MainActivity.java MusicLibraryPlugin.java android-overlay/java/
npm install --no-audit --no-fund
[ -d android ] || npx cap add android

PKG_DIR=android/app/src/main/java/com/soundbeat/player
mkdir -p "$PKG_DIR"
cp android-overlay/java/*.java "$PKG_DIR/"

# --- permissions ---------------------------------------------------------
MANIFEST=android/app/src/main/AndroidManifest.xml
python3 - "$MANIFEST" <<'PY'
import sys, re
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
perms = [
 '<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />',
 '<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />',
 '<uses-permission android:name="android.permission.WAKE_LOCK" />',
]
for line in perms:
    key = re.search(r'android:name="([^"]+)"', line).group(1)
    if key not in s:
        s = s.replace("<application", line + "\n    <application", 1)
open(p, "w", encoding="utf-8").write(s)
PY

# --- launcher icon (optional, never fails the build) ---------------------
RES=android/app/src/main/res
if command -v convert >/dev/null 2>&1; then
  for e in mdpi:48 hdpi:72 xhdpi:96 xxhdpi:144 xxxhdpi:192; do
    d=${e%%:*}; px=${e##*:}
    mkdir -p "$RES/mipmap-$d"
    for n in ic_launcher ic_launcher_round ic_launcher_foreground; do
      convert www/assets/icon.png -resize ${px}x${px} "$RES/mipmap-$d/$n.png" || true
    done
  done
  rm -rf "$RES/mipmap-anydpi-v26"
fi

npx cap sync android
echo "Android project ready in ./android"
