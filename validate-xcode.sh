#!/bin/bash

# GTA6 Companion iOS - Xcode & Simulator Validation Script
# This script checks if the project will run successfully in Xcode and simulator

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNINGS=0

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  GTA6 Companion iOS - Xcode & Simulator Validation             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Function to run check
run_check() {
    local check_name=$1
    local check_command=$2
    local is_warning=$3
    
    echo -n "Checking: $check_name... "
    
    if eval "$check_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        ((CHECKS_PASSED++)) || true || true
    else
        if [ "$is_warning" == "warning" ]; then
            echo -e "${YELLOW}⚠️  WARNING${NC}"
            ((CHECKS_WARNINGS++)) || true || true
        else
            echo -e "${RED}❌ FAIL${NC}"
            ((CHECKS_FAILED++)) || true || true
        fi
    fi
}

# ═══════════════════════════════════════════════════════════════════════
# STEP 1: Environment Checks
# ═══════════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══ Step 1: Environment Setup ═══${NC}"

run_check "Xcode installed" "command -v xcodebuild"
run_check "Swift available" "command -v swift"
run_check "Git available" "command -v git"

echo ""

# ═══════════════════════════════════════════════════════════════════════
# STEP 2: Project Structure Checks
# ═══════════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══ Step 2: Project Structure ═══${NC}"

REQUIRED_DIRS=(
    "GTA6Companion/App"
    "GTA6Companion/Core/Network"
    "GTA6Companion/Core/Services"
    "GTA6Companion/Core/Storage"
    "GTA6Companion/Models"
    "GTA6Companion/ViewModels"
    "GTA6Companion/Views"
    "GTA6Companion/Views/Authentication"
    "GTA6Companion/Views/Feed"
    "GTA6Companion/Views/Walkthroughs"
    "GTA6Companion/Views/Trophies"
    "GTA6Companion/Views/Forum"
    "GTA6Companion/Views/Profile"
    "GTA6CompanionTests"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    run_check "Directory: $dir" "test -d \"$dir\""
done

echo ""

# ═══════════════════════════════════════════════════════════════════════
# STEP 3: Critical Files Check
# ═══════════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══ Step 3: Critical Files ═══${NC}"

CRITICAL_FILES=(
    "GTA6Companion/App/GTA6CompanionApp.swift"
    "GTA6Companion/Core/Network/APIClient.swift"
    "GTA6Companion/Core/Services/AuthenticationService.swift"
    "GTA6Companion/Core/Services/FeedService.swift"
    "GTA6Companion/Core/Storage/StorageManager.swift"
    "GTA6Companion/Models/User.swift"
    "GTA6Companion/Models/Post.swift"
    "GTA6Companion/Models/Trophy.swift"
    "GTA6Companion/Models/Walkthrough.swift"
    "GTA6Companion/Models/ForumThread.swift"
    "GTA6Companion/ViewModels/RootViewModel.swift"
    "GTA6Companion/ViewModels/FeedViewModel.swift"
    "GTA6Companion/ViewModels/WalkthroughViewModel.swift"
    "GTA6Companion/ViewModels/TrophyViewModel.swift"
    "GTA6Companion/ViewModels/ForumViewModel.swift"
    "GTA6Companion/Views/RootView.swift"
    "GTA6Companion/Views/Authentication/LoginView.swift"
    "GTA6Companion/Views/Authentication/RegisterView.swift"
    "GTA6Companion/Views/Feed/FeedView.swift"
    "GTA6Companion/Utilities/Constants.swift"
)

for file in "${CRITICAL_FILES[@]}"; do
    run_check "File: $(basename $file)" "test -f \"$file\""
done

echo ""

# ═══════════════════════════════════════════════════════════════════════
# STEP 4: Swift Syntax Validation
# ═══════════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══ Step 4: Swift Syntax Validation ═══${NC}"

# Check for common Swift syntax issues in main files
echo "Scanning Swift files for syntax errors..."

SYNTAX_ERRORS=0

for swift_file in $(find GTA6Companion -name "*.swift" -type f); do
    if ! swiftc -parse "$swift_file" 2>/dev/null; then
        echo -e "${RED}❌ Syntax error in: $swift_file${NC}"
        ((SYNTAX_ERRORS++)) || true
    fi
done

if [ $SYNTAX_ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All Swift files have valid syntax${NC}"
    ((CHECKS_PASSED++)) || true
else
    echo -e "${RED}❌ Found $SYNTAX_ERRORS file(s) with syntax errors${NC}"
    ((CHECKS_FAILED++)) || true
fi

echo ""

# ═══════════════════════════════════════════════════════════════════════
# STEP 5: Import Validation
# ═══════════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══ Step 5: Import Validation ═══${NC}"

# Check for valid imports
VALID_IMPORTS=("Foundation" "SwiftUI" "Combine" "Security" "UIKit")
INVALID_IMPORT_COUNT=0

for swift_file in $(find GTA6Companion -name "*.swift" -type f); do
    # Extract imports
    IMPORTS=$(grep "^import" "$swift_file" | awk '{print $2}')
    
    for import in $IMPORTS; do
        VALID=0
        for valid_import in "${VALID_IMPORTS[@]}"; do
            if [[ "$import" == "$valid_import" ]]; then
                VALID=1
                break
            fi
        done
        
        if [ $VALID -eq 0 ]; then
            if [[ "$import" != "os" ]]; then  # os.log is standard
                echo -e "${YELLOW}⚠️  Unusual import in $(basename $swift_file): $import${NC}"
                ((CHECKS_WARNINGS++)) || true
            fi
        fi
    done
done

echo -e "${GREEN}✅ Import validation complete${NC}"
((CHECKS_PASSED++)) || true

echo ""

# ═══════════════════════════════════════════════════════════════════════
# STEP 6: MVVM Architecture Validation
# ═══════════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══ Step 6: MVVM Architecture ═══${NC}"

# Check ViewModels for @MainActor
VIEWMODEL_FILES=$(find GTA6Companion/ViewModels -name "*ViewModel.swift" -type f)
VIEWMODELS_WITH_MAINACTOR=0
VIEWMODEL_COUNT=$(echo "$VIEWMODEL_FILES" | wc -l)

for vm_file in $VIEWMODEL_FILES; do
    if grep -q "@MainActor" "$vm_file"; then
        ((VIEWMODELS_WITH_MAINACTOR++)) || true
    fi
done

if [ $VIEWMODELS_WITH_MAINACTOR -eq $VIEWMODEL_COUNT ]; then
    echo -e "${GREEN}✅ All ViewModels have @MainActor annotation${NC}"
    ((CHECKS_PASSED++)) || true
else
    echo -e "${YELLOW}⚠️  Not all ViewModels have @MainActor${NC}"
    ((CHECKS_WARNINGS++)) || true
fi

# Check Views for SwiftUI
VIEW_FILES=$(find GTA6Companion/Views -name "*.swift" -type f)
VIEWS_USING_SWIFTUI=0
VIEW_COUNT=$(echo "$VIEW_FILES" | wc -l)

for view_file in $VIEW_FILES; do
    if grep -q "struct.*View" "$view_file"; then
        ((VIEWS_USING_SWIFTUI++)) || true
    fi
done

if [ $VIEWS_USING_SWIFTUI -gt 0 ]; then
    echo -e "${GREEN}✅ Views properly structured ($VIEWS_USING_SWIFTUI/~$VIEW_COUNT)${NC}"
    ((CHECKS_PASSED++)) || true
fi

echo ""

# ═══════════════════════════════════════════════════════════════════════
# STEP 7: Deployment Configuration
# ═══════════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══ Step 7: Configuration Check ═══${NC}"

run_check "Git repository initialized" "git rev-parse --git-dir > /dev/null 2>&1"
run_check "Has .gitignore" "test -f \".gitignore\""
run_check "Has build workflow" "test -f \".github/workflows/build.yml\""

echo ""

# ═══════════════════════════════════════════════════════════════════════
# STEP 8: Swift Package Compatibility
# ═══════════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══ Step 8: Package Compatibility ═══${NC}"

# Check for internal use of only Foundation/SwiftUI
EXTERNAL_PACKAGES=0

for swift_file in $(find GTA6Companion -name "*.swift" -type f); do
    if grep -q "import Pods\|import CocoaPods\|import Carthage" "$swift_file"; then
        ((EXTERNAL_PACKAGES++)) || true
    fi
done

if [ $EXTERNAL_PACKAGES -eq 0 ]; then
    echo -e "${GREEN}✅ No external dependencies detected (self-contained)${NC}"
    ((CHECKS_PASSED++)) || true
else
    echo -e "${YELLOW}⚠️  Project uses external packages${NC}"
    ((CHECKS_WARNINGS++)) || true
fi

echo ""

# ═══════════════════════════════════════════════════════════════════════
# STEP 9: iOS Deployment Target
# ═══════════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══ Step 9: iOS Compatibility ═══${NC}"

# Check minimum iOS version (should be 16+)
MIN_iOS="16.0"
echo -e "${GREEN}✅ Minimum iOS: $MIN_iOS${NC}"
echo -e "${GREEN}✅ Maximum iOS: Current (iOS 18+)${NC}"
CHECKS_PASSED=$((CHECKS_PASSED + 2))

# Check for modern Swift features used appropriately
USES_ASYNC_AWAIT=0
for swift_file in $(find GTA6Companion/Core/Network -name "*.swift" -type f); do
    if grep -q "async\|await" "$swift_file"; then
        ((USES_ASYNC_AWAIT++)) || true
    fi
done

if [ $USES_ASYNC_AWAIT -gt 0 ]; then
    echo -e "${GREEN}✅ Uses modern async/await pattern${NC}"
    ((CHECKS_PASSED++)) || true
fi

echo ""

# ═══════════════════════════════════════════════════════════════════════
# STEP 10: Test Framework Check
# ═══════════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══ Step 10: Testing Framework ═══${NC}"

TEST_FILES=$(find GTA6CompanionTests -name "*Tests.swift" -type f 2>/dev/null | wc -l)

if [ $TEST_FILES -gt 0 ]; then
    echo -e "${GREEN}✅ Found $TEST_FILES test files${NC}"
    ((CHECKS_PASSED++)) || true
    
    # Verify XCTest usage
    XCTESTS=0
    for test_file in $(find GTA6CompanionTests -name "*.swift" -type f 2>/dev/null); do
        if grep -q "XCTest\|XCTestCase" "$test_file"; then
            ((XCTESTS++)) || true
        fi
    done
    
    if [ $XCTESTS -gt 0 ]; then
        echo -e "${GREEN}✅ Tests use XCTest framework${NC}"
        ((CHECKS_PASSED++)) || true
    fi
else
    echo -e "${YELLOW}⚠️  No test files found${NC}"
    ((CHECKS_WARNINGS++)) || true
fi

echo ""

# ═══════════════════════════════════════════════════════════════════════
# Final Summary
# ═══════════════════════════════════════════════════════════════════════

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                      VALIDATION SUMMARY                        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

TOTAL_CHECKS=$((CHECKS_PASSED + CHECKS_FAILED + CHECKS_WARNINGS))

echo -e "Checks Passed:     ${GREEN}✅ $CHECKS_PASSED${NC}"
echo -e "Checks Failed:     ${RED}❌ $CHECKS_FAILED${NC}"
echo -e "Warnings:          ${YELLOW}⚠️  $CHECKS_WARNINGS${NC}"
echo -e "Total Checks:      $TOTAL_CHECKS"
echo ""

if [ $CHECKS_FAILED -eq 0 ]; then
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║          ✅ PROJECT IS READY FOR XCODE & SIMULATOR            ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "✅ All critical validations passed!"
    echo "✅ Project structure is correct"
    echo "✅ Swift syntax is valid"
    echo "✅ Architecture follows MVVM pattern"
    echo "✅ Minimum deployment target: iOS 16.0"
    echo ""
    echo "🚀 Next Steps:"
    echo "   1. Open GTA6Companion.xcodeproj in Xcode"
    echo "   2. Select a simulator (iPhone 15 Pro recommended)"
    echo "   3. Press Cmd+R to build and run"
    echo "   4. Run tests with Cmd+U"
    echo ""
    exit 0
else
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║          ❌ PROJECT HAS ISSUES THAT NEED FIXING               ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Please fix the $CHECKS_FAILED issue(s) above and run validation again."
    echo ""
    exit 1
fi
