#!/usr/bin/env bash
# Produces a GeckoView AAR with org.webrtc classes removed to avoid duplicate-class
# conflict with flutter_webrtc (ox_calling). Output: libs/geckoview-nightly-no-webrtc.aar
# Usage: ./strip_webrtc_from_geckoview.sh [version]
#   version defaults to 99.0.20220308092232 (or set GECKOVIEW_VERSION)

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIBS_DIR="${SCRIPT_DIR}/libs"
GECKOVIEW_CHANNEL="${GECKOVIEW_CHANNEL:-nightly}"
GECKOVIEW_VERSION="${1:-${GECKOVIEW_VERSION:-99.0.20220308092232}}"
AAR_NAME="geckoview-${GECKOVIEW_CHANNEL}-${GECKOVIEW_VERSION}.aar"
URL="https://maven.mozilla.org/maven2/org/mozilla/geckoview/geckoview-${GECKOVIEW_CHANNEL}/${GECKOVIEW_VERSION}/${AAR_NAME}"
OUT_AAR="${LIBS_DIR}/geckoview-nightly-no-webrtc.aar"
WORK_DIR="${SCRIPT_DIR}/build/geckoview-strip"
CLASSES_JAR="${WORK_DIR}/classes.jar"

mkdir -p "${LIBS_DIR}"
mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"
rm -rf aar_extract classes_extract

echo "Downloading ${AAR_NAME}..."
curl -sSfL -o "${AAR_NAME}" "${URL}"

echo "Unpacking AAR..."
unzip -q -o "${AAR_NAME}" -d aar_extract

echo "Removing org.webrtc from classes.jar..."
mkdir -p classes_extract
cd aar_extract
unzip -q -o classes.jar -d ../classes_extract
cd ../classes_extract
rm -rf org/webrtc
# Repack classes.jar (from classes_extract root)
jar cf "${CLASSES_JAR}" .
cd ..

echo "Replacing classes.jar in AAR..."
cp "${CLASSES_JAR}" aar_extract/classes.jar

echo "Building no-WebRTC AAR..."
cd aar_extract
zip -q -r "${OUT_AAR}" .
cd ..

echo "Cleaning up..."
cd "${SCRIPT_DIR}"
rm -rf "${WORK_DIR}"

echo "Done: ${OUT_AAR}"
echo "You can now build the app as usual (GeckoView is included by default)."
