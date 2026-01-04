#!/bin/bash

# LaTeX Watch Script - Auto-compile on file changes
# Usage: ./watch.sh [options]
# Options:
#   -o, --open    Open PDF in default viewer after compilation
#   -i, --interval SECONDS  Polling interval in seconds (default: 2)
#   -h, --help    Show this help message

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
OPEN_PDF=false
POLL_INTERVAL=2
LATEX_FILE="resume.tex"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--open)
            OPEN_PDF=true
            shift
            ;;
        -i|--interval)
            POLL_INTERVAL="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  -o, --open              Open PDF in default viewer after compilation"
            echo "  -i, --interval SECONDS  Polling interval in seconds (default: 2)"
            echo "  -h, --help              Show this help message"
            echo ""
            echo "This script watches for changes in .tex files and automatically recompiles."
            echo "Press Ctrl+C to stop watching."
            exit 0
            ;;
        *)
            LATEX_FILE="$1"
            shift
            ;;
    esac
done

# Check if LaTeX file exists
if [ ! -f "$LATEX_FILE" ]; then
    echo -e "${RED}Error: File '$LATEX_FILE' not found!${NC}"
    exit 1
fi

# Check if compile.sh exists
if [ ! -f "compile.sh" ]; then
    echo -e "${RED}Error: compile.sh not found!${NC}"
    exit 1
fi

# Get git branch name for output filename
if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
    GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    GIT_BRANCH=$(echo "$GIT_BRANCH" | sed 's/[^a-zA-Z0-9._-]/-/g')
    OUTPUT_NAME="reza-khosroshahi-${GIT_BRANCH}"
else
    OUTPUT_NAME="reza-khosroshahi-main"
fi

BUILD_DIR="build"
OUTPUT_PDF="${BUILD_DIR}/${OUTPUT_NAME}.pdf"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}LaTeX Watch Mode${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Watching: ${YELLOW}$LATEX_FILE${NC} and related .tex files"
echo -e "Output PDF: ${YELLOW}${OUTPUT_PDF}${NC}"
echo -e "Build directory: ${YELLOW}${BUILD_DIR}/${NC}"
echo -e "Polling interval: ${YELLOW}${POLL_INTERVAL}s${NC}"
if [ "$OPEN_PDF" = true ]; then
    echo -e "PDF viewer: ${GREEN}Will open automatically${NC}"
fi
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop watching${NC}"
echo ""

# Function to get modification time of all .tex files
get_tex_files_mtime() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        find . -name "*.tex" -type f -exec stat -f "%m %N" {} \; 2>/dev/null | sort -n | tail -1 | awk '{print $1}'
    else
        # Linux
        find . -name "*.tex" -type f -exec stat -c "%Y %n" {} \; 2>/dev/null | sort -n | tail -1 | awk '{print $1}'
    fi
}

# Function to compile
compile_resume() {
    echo -e "\n${BLUE}[$(date +%H:%M:%S)]${NC} ${YELLOW}Changes detected, compiling...${NC}"
    ./compile.sh > /dev/null 2>&1
    COMPILE_EXIT=$?
    
    if [ $COMPILE_EXIT -eq 0 ] && [ -f "$OUTPUT_PDF" ]; then
        echo -e "${GREEN}✓ Compilation successful!${NC}"
        
        if [ "$OPEN_PDF" = true ]; then
            # Open PDF (macOS)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                open "$OUTPUT_PDF" 2>/dev/null
            # Linux
            elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
                xdg-open "$OUTPUT_PDF" 2>/dev/null || evince "$OUTPUT_PDF" 2>/dev/null
            fi
        fi
    else
        echo -e "${RED}✗ Compilation failed. Check compile.sh output for details.${NC}"
    fi
}

# Initial compilation
echo -e "${YELLOW}Performing initial compilation...${NC}"
compile_resume

# Track last modification time
LAST_MTIME=$(get_tex_files_mtime)

# Watch loop
while true; do
    sleep "$POLL_INTERVAL"
    
    CURRENT_MTIME=$(get_tex_files_mtime)
    
    if [ "$CURRENT_MTIME" != "$LAST_MTIME" ]; then
        LAST_MTIME="$CURRENT_MTIME"
        compile_resume
    fi
done

