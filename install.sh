#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Shtrudel's Launcher Installer ===${NC}"
echo "Fetching latest release information..."

# Get the latest release URL
API_URL="https://api.github.com/repos/Urman24/Shtrudel-s-Launcher/releases/latest"
LATEST_RELEASE=$(curl -s "$API_URL")

# Check if we got a response
if [ -z "$LATEST_RELEASE" ]; then
    echo -e "${RED}Error: Failed to fetch release information${NC}"
    exit 1
fi

# Search for the setup file download URL
DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | grep -o '"browser_download_url": *"[^"]*setup[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$DOWNLOAD_URL" ]; then
    # If no setup file found, look for any exe file
    DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | grep -o '"browser_download_url": *"[^"]*\.exe[^"]*"' | head -1 | cut -d'"' -f4)
fi

if [ -z "$DOWNLOAD_URL" ]; then
    echo -e "${RED}Error: Could not find download file${NC}"
    echo "Please check the repository manually: https://github.com/Urman24/Shtrudel-s-Launcher/releases/latest"
    exit 1
fi

# Get release version
TAG_NAME=$(echo "$LATEST_RELEASE" | grep -o '"tag_name": *"[^"]*"' | cut -d'"' -f4)
echo -e "${YELLOW}Found release: ${TAG_NAME}${NC}"

# Filename for saving
FILENAME=$(basename "$DOWNLOAD_URL")
OUTPUT_FILE="$HOME/Downloads/$FILENAME"

echo "Downloading $FILENAME..."
echo "URL: $DOWNLOAD_URL"

# Download file with progress bar
if curl -L --progress-bar -o "$OUTPUT_FILE" "$DOWNLOAD_URL"; then
    echo -e "${GREEN}✓ File downloaded successfully: $OUTPUT_FILE${NC}"
    echo ""
    echo "To install, run the file via Wine or on a Windows system:"
    echo -e "${YELLOW}wine \"$OUTPUT_FILE\"${NC}"
else
    echo -e "${RED}Error downloading file${NC}"
    exit 1
fi
