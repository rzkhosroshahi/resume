# How to Compile and Run This LaTeX Resume Project

This guide will walk you through all the steps needed to compile this LaTeX resume template into a PDF.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Compilation Methods](#compilation-methods)
4. [Troubleshooting](#troubleshooting)
5. [Project Structure](#project-structure)

---

## Prerequisites

Before compiling, you need:

1. **A LaTeX Distribution** - Choose one based on your operating system:
   - **macOS:** [MacTeX](https://www.tug.org/mactex/) (full ~4GB) or [BasicTeX](https://www.tug.org/mactex/mactex-basictex.html) (~100MB)
   - **Linux:** `sudo apt-get install texlive-full` (Ubuntu/Debian) or `sudo yum install texlive-scheme-full` (Fedora)
   - **Windows:** [MiKTeX](https://miktex.org/) or [TeX Live](https://www.tug.org/texlive/)

2. **Required LaTeX Packages** - See [Installation](#installation) section below

---

## Installation

### Step 1: Install LaTeX Distribution

#### macOS

**Option A: MacTeX (Full Installation)**
```bash
# Using Homebrew
brew install --cask mactex

# Or download from: https://www.tug.org/mactex/
```

**Option B: BasicTeX (Minimal Installation)**
```bash
# Using Homebrew
brew install --cask basictex

# Or download from: https://www.tug.org/mactex/mactex-basictex.html
```

After installation, add TeX to your PATH (if not already added):
```bash
export PATH="/Library/TeX/texbin:$PATH"
```

#### Linux (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install texlive-full
```

#### Linux (Fedora/RHEL)

```bash
sudo yum install texlive-scheme-full
```

#### Windows

1. Download and install [MiKTeX](https://miktex.org/) or [TeX Live](https://www.tug.org/texlive/)
2. Follow the installation wizard
3. MiKTeX will automatically install missing packages when needed

### Step 2: Install Required LaTeX Packages

After installing your LaTeX distribution, install the required packages:

#### Using the Installation Script (Recommended)

```bash
# Make the script executable (first time only)
chmod +x install-packages.sh

# Run the installation script
./install-packages.sh
```

This will install all required packages:
- `sourcesanspro` - Font package
- `moresize` - Font sizing
- `anyfontsize` - Additional font sizes
- `csquotes` - Quotation marks
- `geometry` - Page layout
- `xcolor` - Colors
- `hyperref` - Hyperlinks
- `enumitem` - List formatting
- `titlesec` - Section formatting
- `standalone` - Standalone documents
- `babel` - Language support
- `blindtext` - Placeholder text

#### Manual Installation (macOS/Linux with TeX Live)

```bash
sudo tlmgr install sourcesanspro moresize anyfontsize csquotes geometry xcolor hyperref enumitem titlesec standalone babel blindtext
```

#### Manual Installation (Linux with apt)

```bash
sudo apt-get install texlive-fonts-extra texlive-latex-extra
```

---

## Compilation Methods

### Method 1: Using the Shell Script (Easiest) ⭐ Recommended

The project includes a `compile.sh` script that automates the compilation process.

#### Basic Usage

```bash
# Make sure the script is executable (first time only)
chmod +x compile.sh

# Compile the resume
./compile.sh
```

This will:
- Run `pdflatex` twice (to resolve references)
- Generate `build/reza-khosroshahi-{branch-name}.pdf` in the `build/` directory
- Show progress and error messages

#### Advanced Options

```bash
# Clean auxiliary files after compilation
./compile.sh --clean

# Show verbose output (useful for debugging)
./compile.sh --verbose

# Combine options
./compile.sh --clean --verbose

# Compile a different LaTeX file
./compile.sh other-file.tex

# Show help
./compile.sh --help
```

**Output:** `build/reza-khosroshahi-{branch-name}.pdf` will be created in the `build/` directory (where `{branch-name}` is your current git branch). All output files (PDF, logs, auxiliary files) are placed in the `build/` directory to keep your project clean.

#### Live Watch Mode (Auto-compile on Changes) 🔥

For live editing with automatic recompilation when you save files:

```bash
# Watch for changes and auto-compile
./watch.sh

# Watch and automatically open PDF in viewer
./watch.sh --open

# Custom polling interval (default: 2 seconds)
./watch.sh --interval 1

# Show help
./watch.sh --help
```

**How it works:**
- Watches all `.tex` files in the project
- Automatically recompiles when you save changes
- Shows compilation status and timestamps
- Optionally opens PDF in your default viewer
- Press `Ctrl+C` to stop watching

**Perfect for:** Rapid iteration and live editing!

---

### Method 2: VS Code with LaTeX Workshop Extension

Perfect for editing and compiling in one place.

#### Setup

1. **Install VS Code** (if not already installed)
   - Download from: https://code.visualstudio.com/

2. **Install LaTeX Workshop Extension**
   - Open VS Code
   - Press `Cmd+Shift+X` (Mac) or `Ctrl+Shift+X` (Windows/Linux)
   - Search for "LaTeX Workshop" by James Yu
   - Click "Install"

3. **Open the Project**
   ```bash
   code /path/to/resume-latex-template
   ```

#### Compilation

- **Keyboard Shortcut:** Press `Cmd+Alt+B` (Mac) or `Ctrl+Alt+B` (Windows/Linux)
- **Or:** Click the "Build LaTeX project" button in the LaTeX panel (left sidebar)
- **Or:** Use Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`) → "LaTeX Workshop: Build LaTeX project"

The PDF will automatically open in a new tab within VS Code.

**Configuration:** The project includes `.vscode/settings.json` with optimized LaTeX Workshop settings.

---

### Method 3: Command Line (Manual)

For full control over the compilation process.

#### Basic Compilation

```bash
# Navigate to the project directory
cd /path/to/resume-latex-template

# Compile the LaTeX file
pdflatex resume.tex

# Run again to resolve references (important!)
pdflatex resume.tex
```

#### With Error Handling

```bash
# Compile with error handling
pdflatex -interaction=nonstopmode -file-line-error resume.tex
pdflatex -interaction=nonstopmode -file-line-error resume.tex
```

#### Clean Compilation

```bash
# Compile
pdflatex resume.tex
pdflatex resume.tex

# Clean auxiliary files
rm -f resume.aux resume.log resume.out resume.synctex.gz
```

**Output:** `build/resume.pdf` will be created in the `build/` directory.

---

### Method 4: Overleaf (Online - No Installation Required)

Perfect if you don't want to install LaTeX locally.

1. **Go to Overleaf**
   - Visit: https://www.overleaf.com/
   - Sign up or log in (free account available)

2. **Create New Project**
   - Click "New Project" → "Upload Project"
   - Upload all files from this template:
     - `resume.tex`
     - `_header.tex`
     - `TLCresume.sty`
     - All files in `sections/` directory

3. **Compile**
   - Click the "Recompile" button (top left)
   - The PDF will appear on the right side
   - Download the PDF when ready

**Note:** Overleaf has all packages pre-installed, so no package installation needed!

---

## Troubleshooting

### Error: "pdflatex: command not found"

**Solution:** LaTeX distribution is not installed or not in your PATH.

- **macOS:** Add `/Library/TeX/texbin` to your PATH:
  ```bash
  export PATH="/Library/TeX/texbin:$PATH"
  # Add to ~/.zshrc or ~/.bash_profile to make permanent
  ```
- **Linux:** Install TeX Live (see Installation section)
- **Windows:** Reinstall MiKTeX/TeX Live and ensure it's added to PATH

---

### Error: "File 'sourcesanspro.sty' not found"

**Solution:** Missing LaTeX package. Install it:

```bash
# macOS/Linux with TeX Live
sudo tlmgr install sourcesanspro

# Or use the installation script
./install-packages.sh
```

---

### Error: "Permission denied" when running scripts

**Solution:** Make scripts executable:

```bash
chmod +x compile.sh
chmod +x install-packages.sh
```

---

### Error: "tlmgr: command not found"

**Solution:** `tlmgr` is not in your PATH.

- **macOS:** Add `/Library/TeX/texbin` to PATH (see above)
- **Linux:** Usually included with TeX Live installation
- **Windows:** Usually included with TeX Live installation

---

### PDF looks incorrect or formatting is wrong

**Possible causes:**
1. **Missing packages** - Run `./install-packages.sh` to install all required packages
2. **Old LaTeX distribution** - Update your LaTeX distribution
3. **Cache issues** - Clean auxiliary files:
   ```bash
   rm -f *.aux *.log *.out *.synctex.gz
   ./compile.sh --clean
   ```

---

### Compilation hangs or freezes

**Solution:** The script uses `-halt-on-error` to prevent hanging. If it still hangs:

1. Press `Ctrl+C` to stop
2. Check `resume.log` for errors
3. Run with verbose mode: `./compile.sh --verbose`
4. Check for missing packages or syntax errors in `.tex` files

---

### VS Code LaTeX Workshop not working

**Solutions:**
1. **Check extension is installed** - Verify "LaTeX Workshop" is installed and enabled
2. **Check LaTeX is in PATH** - VS Code needs to find `pdflatex`
3. **Reload VS Code** - Press `Cmd+Shift+P` → "Developer: Reload Window"
4. **Check settings** - Verify `.vscode/settings.json` exists and is correct

---

## Project Structure

```
resume-latex-template/
├── resume.tex              # Main LaTeX file (edit this)
├── _header.tex             # Header definitions
├── TLCresume.sty           # Style file (formatting)
├── compile.sh              # Compilation script
├── install-packages.sh     # Package installation script
├── COMPILE.md              # This file
├── README.md               # Project README
├── .vscode/
│   └── settings.json       # VS Code LaTeX Workshop settings
└── sections/
    ├── skills.tex          # Skills section
    ├── experience.tex      # Work experience section
    ├── projects.tex        # Projects section
    ├── education.tex       # Education section
    ├── activities.tex      # Activities section
    └── certification.tex   # Certifications section
```

---

## Quick Start Checklist

- [ ] Install LaTeX distribution (MacTeX/BasicTeX/TeX Live/MiKTeX)
- [ ] Install required packages (`./install-packages.sh`)
- [ ] Make scripts executable (`chmod +x compile.sh install-packages.sh`)
- [ ] Edit `resume.tex` with your information
- [ ] Compile (`./compile.sh`)
- [ ] Check `build/reza-khosroshahi-{branch-name}.pdf` output

---

## Additional Resources

- [LaTeX Documentation](https://www.latex-project.org/help/documentation/)
- [Overleaf Learn LaTeX](https://www.overleaf.com/learn)
- [TeX Live Documentation](https://www.tug.org/texlive/doc.html)
- [VS Code LaTeX Workshop](https://github.com/James-Yu/LaTeX-Workshop)

---

## Need Help?

If you encounter issues not covered here:

1. Check the error messages in `resume.log`
2. Run `./compile.sh --verbose` for detailed output
3. Verify all packages are installed: `./install-packages.sh`
4. Check that your LaTeX distribution is up to date

---

**Last Updated:** January 2025

