#!/bin/bash

# Paths to the source and destination files
GENERATED_PATH="$SRCROOT/Flutter/Generated.xcconfig"

# Read version and build numbers from the main app's Generated.xcconfig
APP_VERSION=$(grep FLUTTER_BUILD_NAME $GENERATED_PATH | cut -d '=' -f2)
BUILD_NUMBER=$(grep FLUTTER_BUILD_NUMBER $GENERATED_PATH | cut -d '=' -f2)

echo "Read app version $APP_VERSION ($BUILD_NUMBER)"

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $APP_VERSION" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

echo "Set version(s) in $INFOPLIST_PATH to $APP_VERSION ($BUILD_NUMBER)"
