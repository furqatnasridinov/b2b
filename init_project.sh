#!/bin/bash

set -e

APP_NAME=$1
BUNDLE_ID=$2

if [ -z "$APP_NAME" ] || [ -z "$BUNDLE_ID" ]; then
  echo "Usage: ./init_project.sh \"My App\" com.company.myapp"
  exit 1
fi

echo "==> Removing template git history"
rm -rf .git

echo "==> Installing rename tool (if not installed)"
dart pub global activate rename >/dev/null 2>&1 || true

echo "==> Setting app name: $APP_NAME"
rename setAppName --value "$APP_NAME"

echo "==> Setting bundle id: $BUNDLE_ID"
rename setBundleId --value "$BUNDLE_ID"

echo "==> Getting latest dependencies"
flutter pub get

echo "==> Done"
echo "App Name : $APP_NAME"
echo "Bundle ID: $BUNDLE_ID"
