#!/bin/bash

# iOS App Icons Regeneration Script
# This script automates the process of regenerating iOS app icons for all flavors

set -e  # Exit on any error

echo "🍎 Starting iOS App Icons Regeneration..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Navigate to project root (assuming script is in config/app_icon/)
cd "$(dirname "$0")/../.."

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: Could not find Flutter project root directory${NC}"
    exit 1
fi

# Check if ios_icons_launcher.yaml exists
if [ ! -f "ios_icons_launcher.yaml" ]; then
    echo -e "${RED}❌ Error: ios_icons_launcher.yaml not found${NC}"
    exit 1
fi

echo -e "${BLUE}📂 Current directory: $(pwd)${NC}"

# Step 1: Delete existing AppIcon directories
echo -e "${YELLOW}🗑️  Step 1: Removing existing AppIcon directories...${NC}"

ASSETS_DIR="ios/Runner/Assets.xcassets"

if [ -d "$ASSETS_DIR/AppIcon-dev.appiconset" ]; then
    rm -rf "$ASSETS_DIR/AppIcon-dev.appiconset"
    echo -e "${GREEN}✅ Deleted AppIcon-dev.appiconset${NC}"
fi

if [ -d "$ASSETS_DIR/AppIcon-stg.appiconset" ]; then
    rm -rf "$ASSETS_DIR/AppIcon-stg.appiconset"
    echo -e "${GREEN}✅ Deleted AppIcon-stg.appiconset${NC}"
fi

if [ -d "$ASSETS_DIR/AppIcon.appiconset" ]; then
    rm -rf "$ASSETS_DIR/AppIcon.appiconset"
    echo -e "${GREEN}✅ Deleted AppIcon.appiconset${NC}"
fi

# Step 2: Generate new AppIcon directories
echo -e "${YELLOW}🔧 Step 2: Generating new AppIcon directories...${NC}"

# Generate AppIcon-dev
echo -e "${BLUE}📱 Generating AppIcon-dev.appiconset...${NC}"
fvm dart run icons_launcher:create --path ios_icons_launcher.yaml --flavor AppIcon-dev.appiconset
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ AppIcon-dev.appiconset generated successfully${NC}"
else
    echo -e "${RED}❌ Failed to generate AppIcon-dev.appiconset${NC}"
    exit 1
fi

# Generate AppIcon-stg
echo -e "${BLUE}📱 Generating AppIcon-stg.appiconset...${NC}"
fvm dart run icons_launcher:create --path ios_icons_launcher.yaml --flavor AppIcon-stg.appiconset
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ AppIcon-stg.appiconset generated successfully${NC}"
else
    echo -e "${RED}❌ Failed to generate AppIcon-stg.appiconset${NC}"
    exit 1
fi

# Generate AppIcon (production)
echo -e "${BLUE}📱 Generating AppIcon.appiconset...${NC}"
fvm dart run icons_launcher:create --path ios_icons_launcher.yaml --flavor AppIcon.appiconset
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ AppIcon.appiconset generated successfully${NC}"
else
    echo -e "${RED}❌ Failed to generate AppIcon.appiconset${NC}"
    exit 1
fi

# Step 3: Fix naming issues (the icons_launcher creates nested directories)
echo -e "${YELLOW}🔧 Step 3: Fixing directory naming...${NC}"

# Check if the generated directories have the double-naming issue and fix them
if [ -d "$ASSETS_DIR/AppIcon-dev.appiconsetAppIcon.appiconset" ]; then
    mv "$ASSETS_DIR/AppIcon-dev.appiconsetAppIcon.appiconset" "$ASSETS_DIR/AppIcon-dev.appiconset"
    echo -e "${GREEN}✅ Fixed AppIcon-dev.appiconset naming${NC}"
fi

if [ -d "$ASSETS_DIR/AppIcon-stg.appiconsetAppIcon.appiconset" ]; then
    mv "$ASSETS_DIR/AppIcon-stg.appiconsetAppIcon.appiconset" "$ASSETS_DIR/AppIcon-stg.appiconset"
    echo -e "${GREEN}✅ Fixed AppIcon-stg.appiconset naming${NC}"
fi

if [ -d "$ASSETS_DIR/AppIcon.appiconsetAppIcon.appiconset" ]; then
    mv "$ASSETS_DIR/AppIcon.appiconsetAppIcon.appiconset" "$ASSETS_DIR/AppIcon.appiconset"
    echo -e "${GREEN}✅ Fixed AppIcon.appiconset naming${NC}"
fi

# Step 4: Verify the results
echo -e "${YELLOW}🔍 Step 4: Verifying results...${NC}"

EXPECTED_DIRS=("AppIcon-dev.appiconset" "AppIcon-stg.appiconset" "AppIcon.appiconset")
ALL_GOOD=true

for dir in "${EXPECTED_DIRS[@]}"; do
    if [ -d "$ASSETS_DIR/$dir" ]; then
        # Count the number of .png files in the directory
        PNG_COUNT=$(find "$ASSETS_DIR/$dir" -name "*.png" | wc -l)
        echo -e "${GREEN}✅ $dir exists with $PNG_COUNT icon files${NC}"
    else
        echo -e "${RED}❌ $dir is missing${NC}"
        ALL_GOOD=false
    fi
done

if [ "$ALL_GOOD" = true ]; then
    echo -e "${GREEN}🎉 Success! All iOS app icons have been regenerated successfully.${NC}"
    echo -e "${BLUE}📋 Summary:${NC}"
    echo -e "   • AppIcon-dev.appiconset (Development)"
    echo -e "   • AppIcon-stg.appiconset (Staging)" 
    echo -e "   • AppIcon.appiconset (Production)"
    echo -e "${YELLOW}💡 You can now build your iOS app with the updated icons.${NC}"
    echo -e "${BLUE}📝 To run this script: ./config/app_icon/regenerate_ios_icons.sh${NC}"
else
    echo -e "${RED}❌ Some directories are missing. Please check the output above.${NC}"
    exit 1
fi