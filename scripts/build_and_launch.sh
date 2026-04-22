#!/usr/bin/env bash
set -euo pipefail

PROJECT_PATH="${PROJECT_PATH:-Backdropify.xcodeproj}"
SCHEME="${SCHEME:-Backdropify}"
CONFIGURATION="${CONFIGURATION:-Debug}"
SIMULATOR_NAME="${SIMULATOR_NAME:-iPhone 16}"
SIMULATOR_OS="${SIMULATOR_OS:-18.1}"
SIMULATOR_UDID="${SIMULATOR_UDID:-}"
BUNDLE_ID="${BUNDLE_ID:-aniket.walli}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-.build/DerivedData}"
SCREENSHOT_DIR="${SCREENSHOT_DIR:-.build/artifacts}"
ENABLE_SCREENSHOT="${ENABLE_SCREENSHOT:-1}"

if [[ -z "${SIMULATOR_UDID}" ]]; then
  SIMULATOR_UDID="$(
    xcrun simctl list devices available | awk -v os="${SIMULATOR_OS}" '
      $0 ~ ("-- iOS " os " --") { in_os = 1; next }
      /^--/ { in_os = 0 }
      in_os { print }
    ' | grep -F "${SIMULATOR_NAME} (" | head -n 1 | sed -E 's/.*\(([A-F0-9-]+)\).*/\1/'
  )"
fi

if [[ -z "${SIMULATOR_UDID}" ]]; then
  echo "Could not resolve a simulator UDID for ${SIMULATOR_NAME} on iOS ${SIMULATOR_OS}."
  echo "Tip: set SIMULATOR_UDID explicitly."
  exit 1
fi

echo "==> Building scheme '${SCHEME}' for simulator '${SIMULATOR_NAME}' (${SIMULATOR_UDID})"
xcodebuild \
  -project "${PROJECT_PATH}" \
  -scheme "${SCHEME}" \
  -configuration "${CONFIGURATION}" \
  -destination "id=${SIMULATOR_UDID}" \
  -derivedDataPath "${DERIVED_DATA_PATH}" \
  build

echo "==> Booting simulator"
xcrun simctl boot "${SIMULATOR_UDID}" >/dev/null 2>&1 || true
xcrun simctl bootstatus "${SIMULATOR_UDID}" -b

APP_PATH="$(find "${DERIVED_DATA_PATH}/Build/Products/${CONFIGURATION}-iphonesimulator" -maxdepth 1 -name "*.app" | head -n 1)"
if [[ -z "${APP_PATH}" ]]; then
  echo "No app bundle found in ${DERIVED_DATA_PATH}/Build/Products/${CONFIGURATION}-iphonesimulator"
  exit 1
fi

echo "==> Installing ${APP_PATH}"
xcrun simctl install "${SIMULATOR_UDID}" "${APP_PATH}"

echo "==> Launching ${BUNDLE_ID}"
xcrun simctl launch "${SIMULATOR_UDID}" "${BUNDLE_ID}"

if [[ "${ENABLE_SCREENSHOT}" == "1" ]]; then
  mkdir -p "${SCREENSHOT_DIR}"
  SCREENSHOT_PATH="${SCREENSHOT_DIR}/${SCHEME}-$(date +%Y%m%d-%H%M%S).png"
  echo "==> Capturing screenshot ${SCREENSHOT_PATH}"
  xcrun simctl io "${SIMULATOR_UDID}" screenshot "${SCREENSHOT_PATH}" >/dev/null
fi

echo "==> Done"
