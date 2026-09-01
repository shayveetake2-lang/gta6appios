#!/bin/sh

# Diagnostic script to verify GoogleService-Info.plist is present.
# Prints a setup warning to the developer console on compilation if missing.

PLIST_PATH="${SRCROOT}/GTA6Companion/GoogleService-Info.plist"

if [ ! -f "$PLIST_PATH" ]; then
    echo "warning: ⚠️ GoogleService-Info.plist is missing from the workspace directory."
    echo "warning: Download it from your Firebase Console and add it to the 'GTA6Companion' directory."
    echo "warning: The app will crash on launch without this configuration."
else
    echo "note: GoogleService-Info.plist found at $PLIST_PATH"
fi

