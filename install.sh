#!/bin/bash

# Shtrudel's Launcher Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/Urman24/Shtrudel-s-Launcher/main/install.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}╔═══════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Shtrudel's Launcher Installer       ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════╝${NC}"
echo ""

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS_TYPE=linux;;
    Darwin*)    OS_TYPE=macos;;
    *)          echo -e "${RED}Unsupported OS: ${OS}${NC}"; exit 1;;
esac

echo -e "${YELLOW}Detected OS: ${OS_TYPE}${NC}"
echo -e "${YELLOW}Fetching latest release...${NC}"

# Get latest release info
API_URL="https://api.github.com/repos/Urman24/Shtrudel-s-Launcher/releases/latest"
RELEASE_INFO=$(curl -s "$API_URL")

if [ -z "$RELEASE_INFO" ]; then
    echo -e "${RED}Error: Failed to fetch release information${NC}"
    exit 1
fi

# Find download URL
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep -o '"browser_download_url": *"[^"]*"' | grep -i "setup\|\.exe" | head -1 | cut -d'"' -f4)

if [ -z "$DOWNLOAD_URL" ]; then
    DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep -o '"browser_download_url": *"[^"]*"' | head -1 | cut -d'"' -f4)
fi

if [ -z "$DOWNLOAD_URL" ]; then
    echo -e "${RED}Error: No download URL found${NC}"
    exit 1
fi

# Get version
TAG_NAME=$(echo "$RELEASE_INFO" | grep -o '"tag_name": *"[^"]*"' | cut -d'"' -f4)
echo -e "${GREEN}Latest version: ${TAG_NAME}${NC}"

# Setup temp directory
TMP_DIR=$(mktemp -d)
FILENAME=$(basename "$DOWNLOAD_URL")
OUTPUT_FILE="$TMP_DIR/$FILENAME"

echo -e "${YELLOW}Downloading ${FILENAME}...${NC}"

# Download file
if curl -L --progress-bar -o "$OUTPUT_FILE" "$DOWNLOAD_URL"; then
    echo -e "${GREEN}✓ Download complete!${NC}"
else
    echo -e "${RED}Error: Download failed${NC}"
    rm -rf "$TMP_DIR"
    exit 1
fi

# Instructions for running
echo ""
echo -e "${GREEN}✓ Shtrudel's Launcher downloaded to: ${OUTPUT_FILE}${NC}"
echo ""
echo -e "${YELLOW}This is a Windows executable (.exe)${NC}"
echo -e "To run it, you need Wine installed."
echo ""

# Check if Wine is installed
if command -v wine &> /dev/null; then
    echo -e "${GREEN}Wine detected! Starting launcher...${NC}"
    wine "$OUTPUT_FILE"
else
    echo -e "${YELLOW}Wine is not installed. Install it first:${NC}"
    echo "  Ubuntu/Debian: sudo apt install wine"
    echo "  Fedora: sudo dnf install wine"
    echo "  Arch: sudo pacman -S wine"
    echo "  macOS: brew install wine"
    echo ""
    echo -e "Then run: ${CYAN}wine ${OUTPUT_FILE}${NC}"
fi

# Cleanup on exit
trap "rm -rf $TMP_DIR" EXIT
