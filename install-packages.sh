#!/bin/bash

# Script to install required LaTeX packages for the resume template
# Usage: ./install-packages.sh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if tlmgr is available
if ! command -v tlmgr &> /dev/null; then
    echo -e "${RED}Error: tlmgr is not found!${NC}"
    echo "Please make sure TeX Live is installed and tlmgr is in your PATH"
    exit 1
fi

echo -e "${GREEN}Installing required LaTeX packages...${NC}"
echo ""

# List of required packages based on TLCresume.sty
PACKAGES=(
    "sourcesanspro"
    "moresize"
    "anyfontsize"
    "csquotes"
    "geometry"
    "xcolor"
    "hyperref"
    "enumitem"
    "titlesec"
    "standalone"
    "babel"
    "blindtext"
    "svn-prov"
    "ly1"  # Provides ly1 encoding (ly1enc.def) needed by sourcesanspro
)

# Install each package
for package in "${PACKAGES[@]}"; do
    echo -e "${YELLOW}Installing $package...${NC}"
    sudo tlmgr install "$package" 2>&1 | grep -E "(already installed|installed|error)" || true
done

echo ""
echo -e "${GREEN}✓ Package installation complete!${NC}"
echo ""
echo "You can now compile your resume with: ./compile.sh"

