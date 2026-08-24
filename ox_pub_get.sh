#!/usr/bin/env bash
# Resolve dependencies for the 0xchat monorepo.
#
# Every package now lives in this repository and is wired up as a local path
# dependency in pubspec.yaml:
#
#   packages/0xchat-core          packages/nostr-dart
#   packages/base_framework/*     packages/cashu-dart
#   packages/business_modules/*
#
# There are no submodules left to initialise and no per-package branches to
# check out, so `flutter pub get` resolves the whole workspace on its own.
# This script is kept as the entry point the README and existing workflows
# already point at.

set -e

cd "$(dirname "$0")"

if [ $# -gt 0 ]; then
    echo "note: ox_pub_get.sh no longer takes arguments (got: $*)" >&2
    echo "      -m only existed to check out branches back when the packages" >&2
    echo "      lived in separate repositories. Use git directly instead." >&2
fi

flutter pub get
