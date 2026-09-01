#!/bin/bash

# GTA6 Companion iOS Setup Script
# This script helps set up the Xcode project

set -e

echo "🚀 GTA6 Companion iOS Setup Script"
echo "===================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Xcode is installed
if ! command -v xcode-select &> /dev/null; then
    echo -e "${RED}❌ Xcode is not installed${NC}"
    echo "Please install Xcode from App Store"
    exit 1
fi

echo -e "${GREEN}✅ Xcode found${NC}"
echo "Xcode version: $(xcodebuild -version | head -n1)"
echo ""

# Check if we're in the right directory
if [ ! -f "GTA6Companion/App/GTA6CompanionApp.swift" ]; then
    echo -e "${RED}❌ Please run this script from the project root directory${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Project structure verified${NC}"
echo ""

# Clean build folder
echo "🧹 Cleaning build artifacts..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*GTA6*

# Verify Swift files
echo "📦 Verifying Swift files..."
SWIFT_FILES=$(find GTA6Companion -name "*.swift" | wc -l)
echo "Found $SWIFT_FILES Swift files"

if [ $SWIFT_FILES -lt 20 ]; then
    echo -e "${YELLOW}⚠️  Warning: Expected more Swift files${NC}"
fi

# Check for required files
echo ""
echo "📋 Checking required files..."

REQUIRED_FILES=(
    "GTA6Companion/App/GTA6CompanionApp.swift"
    "GTA6Companion/Core/Network/APIClient.swift"
    "GTA6Companion/Core/Services/AuthenticationService.swift"
    "GTA6Companion/Models/User.swift"
    "GTA6Companion/ViewModels/RootViewModel.swift"
    "GTA6Companion/Views/RootView.swift"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file${NC}"
    else
        echo -e "${RED}❌ Missing: $file${NC}"
        exit 1
    fi
done

echo ""
echo -e "${GREEN}✅ All checks passed!${NC}"
echo ""
echo "📚 Next steps:"
echo "1. Open GTA6Companion.xcodeproj in Xcode"
echo "2. Select your target device (simulator or device)"
echo "3. Press Cmd+R to build and run"
echo ""
echo "💡 Tips:"
echo "   - Use Cmd+Shift+K to clean build folder"
echo "   - Use Cmd+U to run unit tests"
echo "   - Check Console (Cmd+Shift+C) for debug output"
echo ""
echo "🎉 Setup complete!"
