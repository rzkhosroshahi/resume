#!/bin/bash

# LaTeX to PDF Compilation Script
# Usage: ./compile.sh [options]
# Options:
#   -c, --clean    Clean auxiliary files after compilation
#   -v, --verbose  Show verbose output
#   -h, --help     Show this help message

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
CLEAN=false
VERBOSE=false
LATEX_FILE="resume.tex"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  -c, --clean    Clean auxiliary files after compilation"
            echo "  -v, --verbose  Show verbose output"
            echo "  -h, --help     Show this help message"
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

# Check if pdflatex is installed
if ! command -v pdflatex &> /dev/null; then
    echo -e "${RED}Error: pdflatex is not installed!${NC}"
    echo "Please install a LaTeX distribution:"
    echo "  macOS: brew install --cask mactex or brew install --cask basictex"
    echo "  Linux: sudo apt-get install texlive-full"
    echo "  Windows: Install MiKTeX or TeX Live"
    exit 1
fi

# Get the base name without extension
BASE_NAME="${LATEX_FILE%.tex}"

# Get git branch name for output filename
if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
    GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    # Sanitize branch name (replace invalid filename characters with hyphens)
    GIT_BRANCH=$(echo "$GIT_BRANCH" | sed 's/[^a-zA-Z0-9._-]/-/g')
    OUTPUT_NAME="reza-khosroshahi-${GIT_BRANCH}"
else
    GIT_BRANCH="main"
    OUTPUT_NAME="reza-khosroshahi-main"
fi

# Create build directory if it doesn't exist
BUILD_DIR="build"
mkdir -p "$BUILD_DIR"

echo -e "${GREEN}Compiling LaTeX file: $LATEX_FILE${NC}"
echo -e "${YELLOW}Output PDF will be: ${BUILD_DIR}/${OUTPUT_NAME}.pdf${NC}"

# First compilation
echo -e "${YELLOW}Running pdflatex (first pass)...${NC}"
if [ "$VERBOSE" = true ]; then
    pdflatex -interaction=nonstopmode -file-line-error -halt-on-error -output-directory="$BUILD_DIR" -jobname="$OUTPUT_NAME" "$LATEX_FILE" 2>&1 | tee /tmp/latex_output.log
    COMPILE_EXIT_CODE=${PIPESTATUS[0]}
else
    pdflatex -interaction=nonstopmode -file-line-error -halt-on-error -output-directory="$BUILD_DIR" -jobname="$OUTPUT_NAME" "$LATEX_FILE" > /tmp/latex_output.log 2>&1
    COMPILE_EXIT_CODE=$?
fi

# Check if compilation was successful
if [ $COMPILE_EXIT_CODE -ne 0 ]; then
    echo -e "${RED}Error: First compilation failed!${NC}"
    
    # Check for missing package/encoding errors
    # Determine which log file exists (pdflatex creates log with jobname in build directory)
    LOG_FILE="${BUILD_DIR}/${OUTPUT_NAME}.log"
    [ ! -f "$LOG_FILE" ] && LOG_FILE="${BUILD_DIR}/${BASE_NAME}.log"
    [ ! -f "$LOG_FILE" ] && LOG_FILE="${BASE_NAME}.log"
    
    if [ -f "$LOG_FILE" ]; then
        # Check for missing .sty files
        MISSING_PACKAGE=$(grep -i "File.*\.sty.*not found" "$LOG_FILE" | head -1 | sed -n "s/.*File \`\(.*\)\.sty'.*/\1/p")
        
        # Check for missing encoding files (like ly1enc.def)
        MISSING_ENCODING=$(grep -i "Encoding file.*not found" "$LOG_FILE" | head -1 | sed -n "s/.*Encoding file \`\(.*\)'.*/\1/p")
        
        if [ -n "$MISSING_PACKAGE" ]; then
            echo -e "${YELLOW}Missing LaTeX package detected: ${MISSING_PACKAGE}${NC}"
            echo ""
            echo "To install missing packages:"
            if command -v tlmgr &> /dev/null; then
                echo -e "  ${GREEN}sudo tlmgr install ${MISSING_PACKAGE}${NC}"
            elif command -v brew &> /dev/null; then
                echo "  If using BasicTeX, install packages with:"
                echo -e "  ${GREEN}sudo tlmgr install ${MISSING_PACKAGE}${NC}"
                echo "  (Make sure tlmgr is in your PATH)"
            else
                echo "  Install the package using your LaTeX distribution's package manager"
            fi
            echo ""
        elif [ -n "$MISSING_ENCODING" ]; then
            echo -e "${YELLOW}Missing encoding file detected: ${MISSING_ENCODING}${NC}"
            echo ""
            echo "This usually means a font encoding package is missing."
            echo "To fix this, install the ly1 package:"
            if command -v tlmgr &> /dev/null; then
                echo -e "  ${GREEN}sudo tlmgr install ly1${NC}"
            else
                echo "  Install 'ly1' package using your LaTeX distribution's package manager"
            fi
            echo ""
            echo "After installing, run: ./install-packages.sh"
            echo ""
        fi
    fi
    
    if [ "$VERBOSE" = false ]; then
        echo "Run with -v flag to see detailed error messages"
        echo "Or check ${BUILD_DIR}/${OUTPUT_NAME}.log for more details"
    fi
    exit 1
fi

# Second compilation (to resolve references)
echo -e "${YELLOW}Running pdflatex (second pass)...${NC}"
if [ "$VERBOSE" = true ]; then
    pdflatex -interaction=nonstopmode -file-line-error -halt-on-error -output-directory="$BUILD_DIR" -jobname="$OUTPUT_NAME" "$LATEX_FILE" 2>&1 | tee /tmp/latex_output.log
    COMPILE_EXIT_CODE=${PIPESTATUS[0]}
else
    pdflatex -interaction=nonstopmode -file-line-error -halt-on-error -output-directory="$BUILD_DIR" -jobname="$OUTPUT_NAME" "$LATEX_FILE" > /tmp/latex_output.log 2>&1
    COMPILE_EXIT_CODE=$?
fi

# Check if compilation was successful
if [ $COMPILE_EXIT_CODE -ne 0 ]; then
    echo -e "${RED}Error: Second compilation failed!${NC}"
    
    # Check for missing package/encoding errors
    # Determine which log file exists (pdflatex creates log with jobname in build directory)
    LOG_FILE="${BUILD_DIR}/${OUTPUT_NAME}.log"
    [ ! -f "$LOG_FILE" ] && LOG_FILE="${BUILD_DIR}/${BASE_NAME}.log"
    [ ! -f "$LOG_FILE" ] && LOG_FILE="${BASE_NAME}.log"
    
    if [ -f "$LOG_FILE" ]; then
        # Check for missing .sty files
        MISSING_PACKAGE=$(grep -i "File.*\.sty.*not found" "$LOG_FILE" | head -1 | sed -n "s/.*File \`\(.*\)\.sty'.*/\1/p")
        
        # Check for missing encoding files (like ly1enc.def)
        MISSING_ENCODING=$(grep -i "Encoding file.*not found" "$LOG_FILE" | head -1 | sed -n "s/.*Encoding file \`\(.*\)'.*/\1/p")
        
        if [ -n "$MISSING_PACKAGE" ]; then
            echo -e "${YELLOW}Missing LaTeX package detected: ${MISSING_PACKAGE}${NC}"
            echo ""
            echo "To install missing packages:"
            if command -v tlmgr &> /dev/null; then
                echo -e "  ${GREEN}sudo tlmgr install ${MISSING_PACKAGE}${NC}"
            elif command -v brew &> /dev/null; then
                echo "  If using BasicTeX, install packages with:"
                echo -e "  ${GREEN}sudo tlmgr install ${MISSING_PACKAGE}${NC}"
                echo "  (Make sure tlmgr is in your PATH)"
            else
                echo "  Install the package using your LaTeX distribution's package manager"
            fi
            echo ""
        elif [ -n "$MISSING_ENCODING" ]; then
            echo -e "${YELLOW}Missing encoding file detected: ${MISSING_ENCODING}${NC}"
            echo ""
            echo "This usually means a font encoding package is missing."
            echo "To fix this, install the ly1 package:"
            if command -v tlmgr &> /dev/null; then
                echo -e "  ${GREEN}sudo tlmgr install ly1${NC}"
            else
                echo "  Install 'ly1' package using your LaTeX distribution's package manager"
            fi
            echo ""
            echo "After installing, run: ./install-packages.sh"
            echo ""
        fi
    fi
    
    if [ "$VERBOSE" = false ]; then
        echo "Run with -v flag to see detailed error messages"
        echo "Or check ${BUILD_DIR}/${OUTPUT_NAME}.log for more details"
    fi
    exit 1
fi

# Check if PDF was created
if [ -f "${BUILD_DIR}/${OUTPUT_NAME}.pdf" ]; then
    echo -e "${GREEN}✓ Successfully compiled: ${BUILD_DIR}/${OUTPUT_NAME}.pdf${NC}"
else
    echo -e "${RED}Error: PDF file was not created!${NC}"
    exit 1
fi

# Compile cover letter if it exists
COVER_LETTER="cover_letter.tex"
if [ -f "$COVER_LETTER" ]; then
    echo ""
    echo -e "${GREEN}Compiling cover letter: $COVER_LETTER${NC}"
    COVER_BASE_NAME="${COVER_LETTER%.tex}"
    COVER_OUTPUT_NAME="cover-letter-${GIT_BRANCH:-main}"
    
    # First compilation
    echo -e "${YELLOW}Running pdflatex (first pass)...${NC}"
    if [ "$VERBOSE" = true ]; then
        pdflatex -interaction=nonstopmode -file-line-error -halt-on-error -output-directory="$BUILD_DIR" -jobname="$COVER_OUTPUT_NAME" "$COVER_LETTER" 2>&1 | tee /tmp/latex_cover_output.log
        COVER_COMPILE_EXIT_CODE=${PIPESTATUS[0]}
    else
        pdflatex -interaction=nonstopmode -file-line-error -halt-on-error -output-directory="$BUILD_DIR" -jobname="$COVER_OUTPUT_NAME" "$COVER_LETTER" > /tmp/latex_cover_output.log 2>&1
        COVER_COMPILE_EXIT_CODE=$?
    fi
    
    if [ $COVER_COMPILE_EXIT_CODE -eq 0 ]; then
        # Second compilation
        echo -e "${YELLOW}Running pdflatex (second pass)...${NC}"
        if [ "$VERBOSE" = true ]; then
            pdflatex -interaction=nonstopmode -file-line-error -halt-on-error -output-directory="$BUILD_DIR" -jobname="$COVER_OUTPUT_NAME" "$COVER_LETTER" 2>&1 | tee /tmp/latex_cover_output.log
            COVER_COMPILE_EXIT_CODE=${PIPESTATUS[0]}
        else
            pdflatex -interaction=nonstopmode -file-line-error -halt-on-error -output-directory="$BUILD_DIR" -jobname="$COVER_OUTPUT_NAME" "$COVER_LETTER" > /tmp/latex_cover_output.log 2>&1
            COVER_COMPILE_EXIT_CODE=$?
        fi
        
        if [ $COVER_COMPILE_EXIT_CODE -eq 0 ] && [ -f "${BUILD_DIR}/${COVER_OUTPUT_NAME}.pdf" ]; then
            echo -e "${GREEN}✓ Successfully compiled cover letter: ${BUILD_DIR}/${COVER_OUTPUT_NAME}.pdf${NC}"
        else
            echo -e "${YELLOW}Warning: Cover letter compilation had issues${NC}"
        fi
    else
        echo -e "${YELLOW}Warning: Cover letter compilation failed (non-fatal)${NC}"
    fi
fi

# Clean auxiliary files if requested
if [ "$CLEAN" = true ]; then
    echo -e "${YELLOW}Cleaning auxiliary files...${NC}"
    rm -f "${BUILD_DIR}/${OUTPUT_NAME}.aux" \
          "${BUILD_DIR}/${OUTPUT_NAME}.log" \
          "${BUILD_DIR}/${OUTPUT_NAME}.out" \
          "${BUILD_DIR}/${OUTPUT_NAME}.synctex.gz" \
          "${BUILD_DIR}/${OUTPUT_NAME}.toc" \
          "${BUILD_DIR}/${OUTPUT_NAME}.lof" \
          "${BUILD_DIR}/${OUTPUT_NAME}.lot" \
          "${BUILD_DIR}/${OUTPUT_NAME}.bbl" \
          "${BUILD_DIR}/${OUTPUT_NAME}.blg" \
          "${BUILD_DIR}/${OUTPUT_NAME}.idx" \
          "${BUILD_DIR}/${OUTPUT_NAME}.ind" \
          "${BUILD_DIR}/${OUTPUT_NAME}.ilg" \
          "${BUILD_DIR}/${OUTPUT_NAME}.nav" \
          "${BUILD_DIR}/${OUTPUT_NAME}.snm" \
          "${BUILD_DIR}/${OUTPUT_NAME}.fdb_latexmk" \
          "${BUILD_DIR}/${OUTPUT_NAME}.fls"
    # Clean cover letter auxiliary files if they exist
    if [ -f "cover_letter.tex" ]; then
        COVER_OUTPUT_NAME="cover-letter-${GIT_BRANCH}"
        rm -f "${BUILD_DIR}/${COVER_OUTPUT_NAME}.aux" \
              "${BUILD_DIR}/${COVER_OUTPUT_NAME}.log" \
              "${BUILD_DIR}/${COVER_OUTPUT_NAME}.out" \
              "${BUILD_DIR}/${COVER_OUTPUT_NAME}.synctex.gz"
    fi
    echo -e "${GREEN}✓ Cleaned auxiliary files${NC}"
fi

echo -e "${GREEN}Done!${NC}"

