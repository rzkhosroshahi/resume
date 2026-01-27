

### Tools used:

- Overleaf
- VS Code

## 📖 Documentation

**For detailed compilation instructions, see [COMPILE.md](./COMPILE.md)** - A comprehensive guide covering installation, compilation methods, troubleshooting, and more.

## Installing Required Packages

If you encounter errors about missing LaTeX packages (like `sourcesanspro.sty not found`), install them using:

### Quick Install (macOS/Linux with TeX Live)

```bash
# Run the installation script (installs all required packages)
./install-packages.sh

# Or install packages manually
sudo tlmgr install sourcesanspro moresize anyfontsize csquotes geometry xcolor hyperref enumitem titlesec standalone babel blindtext
```

### Manual Installation

- **macOS with BasicTeX:** `sudo tlmgr install <package-name>`
- **Linux:** `sudo apt-get install texlive-<package-name>` or use `tlmgr`
- **Windows with MiKTeX:** MiKTeX will prompt to install missing packages automatically

## How to Compile

### Option 1: VS Code with LaTeX Workshop Extension (Recommended)

1. **Install LaTeX Workshop Extension:**
   - Open VS Code
   - Go to Extensions (Cmd+Shift+X on Mac)
   - Search for "LaTeX Workshop" by James Yu
   - Click Install

2. **Install LaTeX Distribution:**
   - **macOS:** Install [MacTeX](https://www.tug.org/mactex/) (large download ~4GB) or [BasicTeX](https://www.tug.org/mactex/mactex-basictex.html) (~100MB)
   - **Linux:** `sudo apt-get install texlive-full` (Ubuntu/Debian) or `sudo yum install texlive-scheme-full` (Fedora)
   - **Windows:** Install [MiKTeX](https://miktex.org/) or [TeX Live](https://www.tug.org/texlive/)

3. **Compile:**
   - Open `resume.tex` in VS Code
   - Press `Cmd+Alt+B` (Mac) or `Ctrl+Alt+B` (Windows/Linux) to build
   - Or click the "Build LaTeX project" button in the LaTeX panel
   - The PDF will open automatically in a new tab

### Option 2: Shell Script (Easiest Command Line Method)

Use the provided `compile.sh` script:

```bash
# Make sure the script is executable (first time only)
chmod +x compile.sh

# Compile the resume
./compile.sh

# Or with options:
./compile.sh --clean      # Clean auxiliary files after compilation
./compile.sh --verbose    # Show detailed output
./compile.sh --help       # Show help message
```

The PDF will be generated as `build/reza-khosroshahi-{branch-name}.pdf` (where `{branch-name}` is your current git branch). All output files (PDF, logs, auxiliary files) are placed in the `build/` directory to keep your project clean.

#### Live Watch Mode (Auto-compile on changes)

For live editing with automatic recompilation:

```bash
# Watch for changes and auto-compile
./watch.sh

# Watch and automatically open PDF in viewer
./watch.sh --open

# Custom polling interval (default: 2 seconds)
./watch.sh --interval 1
```

This will watch all `.tex` files and automatically recompile when you save changes. Press `Ctrl+C` to stop.

### Option 3: Manual Command Line

```bash
# Navigate to the project directory
cd /Users/reza/Documents/resume-latex-template

# Compile the LaTeX file
pdflatex resume.tex

# Run twice to resolve references (if needed)
pdflatex resume.tex
```

The PDF will be generated as `build/resume.pdf` in the build directory.

### Option 4: Overleaf (Online)

1. Go to [Overleaf](https://www.overleaf.com/)
2. Create a new project
3. Upload all files from this template
4. Click "Recompile" to generate the PDF

### Files:

- resume.tex: Main file
- \_header.tex: header code
- TLCresume.sty: style file containing formatting details
- section/skills: table of skills
- section/education: schools and stuff
- section/activities: optional, could comment out in resume.tex.
- section/certification: contains certification details with links.

### Credits:

Author: [Timmy Chan](https://www.overleaf.com/latex/templates/data-science-tech-resume-template/zcdmpfxrzjhv)

### Last Updated: September 1, 2024.
