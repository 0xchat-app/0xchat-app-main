#!/bin/bash
# Launcher that enables GDK device safety wrapper and X11 backend to avoid
# Gdk-CRITICAL (gdk_device_get_source assertion) on Linux. Use this when
# running the built bundle or when launching via flutter run.
#
# Usage (from project root):
#   ./linux/run_with_gdk_fix.sh
# or after building:
#   ./build/linux/x64/release/bundle/run_with_gdk_fix.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUNDLE_DIR=""
BINARY_NAME="oxchat_app_main"
WRAPPER_SO="libgdk_device_safe.so"

# Prefer bundle dir next to this script (e.g. build/linux/x64/release/bundle)
if [ -f "$SCRIPT_DIR/$BINARY_NAME" ]; then
  BUNDLE_DIR="$SCRIPT_DIR"
elif [ -f "$SCRIPT_DIR/lib/$WRAPPER_SO" ]; then
  BUNDLE_DIR="$SCRIPT_DIR"
fi

# If not found, try project root and common build paths
if [ -z "$BUNDLE_DIR" ]; then
  ROOT="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)"
  for dir in "$ROOT/build/linux/x64/release/bundle" "$ROOT/build/linux/x64/debug/bundle" "$SCRIPT_DIR/../build/linux/x64/release/bundle"; do
    if [ -f "$dir/$BINARY_NAME" ]; then
      BUNDLE_DIR="$dir"
      break
    fi
  done
fi

if [ -z "$BUNDLE_DIR" ] || [ ! -f "$BUNDLE_DIR/$BINARY_NAME" ]; then
  echo "Error: $BINARY_NAME not found. Build the Linux app first (e.g. flutter build linux)."
  exit 1
fi

cd "$BUNDLE_DIR"

# Use X11 backend to reduce Wayland-related device bugs (GNOME Bug 753185)
export GDK_BACKEND="${GDK_BACKEND:-x11}"

# Raise FD limit to avoid "Too many open files" / GTK bail out (g-io-error-quark 31).
# Run with: bash ./run_with_gdk_fix.sh  (so ulimit is available). If ulimit is not
# available, set LimitNOFILE=65536 in systemd or run: ulimit -n 65536 && ./oxchat_app_main
if type ulimit >/dev/null 2>&1; then
  ulimit -n 65536 2>/dev/null || true
fi

# Optional: preload GDK device wrapper to avoid gdk_device_get_source CRITICAL
WRAPPER_PATH="$BUNDLE_DIR/lib/$WRAPPER_SO"
if [ -f "$WRAPPER_PATH" ]; then
  export LD_PRELOAD="${LD_PRELOAD:+$LD_PRELOAD:}$WRAPPER_PATH"
fi

exec "./$BINARY_NAME" "$@"
