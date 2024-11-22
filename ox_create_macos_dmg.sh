#!/bin/bash
set -e

test -f oxchat_app_main.dmg && rm oxchat_app_main.dmg

APP_NAME="oxchat_app_main"
APP_PATH="build/macos/Build/Products/Release/oxchat_app_main.app"
DMG_NAME="${APP_NAME}"
OUTPUT_DIR="build/macos/Build/Products/Release/"

if [ ! -d "$APP_PATH" ]; then
  echo "Error: Application not found at $APP_PATH"
  exit 1
fi

flutter build macos --release

APP_PATH="build/macos/Build/Products/Release/oxchat_app_main.app"

echo "Creating DMG..."
create-dmg \
  --volname "$APP_NAME" \
  --window-size "500 300" \
  "$APP_PATH" \
  "$OUTPUT_DIR"

echo "DMG file created successfully: $OUTPUT_DIR/$DMG_NAME.dmg"