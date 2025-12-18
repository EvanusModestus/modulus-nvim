# Modulus-nvim

> A truly modular Neovim configuration built for clarity, flexibility, and performance

Modulus is a comprehensive, production-ready Neovim configuration designed with modularity at its core. It provides a complete IDE experience while remaining transparent and easy to understand—perfect for both daily use and learning how to build your own configuration.

## Why Modulus?

- **Truly Modular**: Clean separation of concerns with organized module structure
- **Production Ready**: Battle-tested features for professional development workflows
- **Fast**: Ultra-fast completion with blink.cmp (Rust-powered SIMD fuzzy matching)
- **Cross-Platform**: Works seamlessly on Windows, Linux, macOS, and WSL
  - Tested on: Ubuntu, Arch, Fedora, macOS, Windows 10/11
- **Well-Documented**: Every feature explained with extensive documentation
- **Learning-Friendly**: Code is clear, commented, and educational

## Key Features

### Core Development Tools
- **LSP Support**: Full language server protocol with Mason integration
- **Intelligent Completion**: blink.cmp with LSP, snippets, and buffer sources
- **File Navigation**: Telescope fuzzy finder, Oil.nvim file manager, and Harpoon
- **Git Integration**: Fugitive and Gitsigns for comprehensive Git workflows
- **Debugging**: DAP (Debug Adapter Protocol) for multiple languages
- **Syntax Highlighting**: Tree-sitter based parsing

### Advanced Features
- **Session Management**: Auto-persist your workspaces
- **Code Folding**: nvim-ufo for beautiful fold displays
- **REST Client**: Test APIs directly from Neovim
- **Markdown Support**: Live preview and enhanced editing
- **Terminal Integration**: Toggleterm for embedded terminals

## Installation

> **IMPORTANT: Read Prerequisites First!**
> **Installing prerequisites BEFORE launching Neovim is critical to prevent installation failures.**
> Don't skip ahead - follow the steps in order.

### Prerequisites

You **MUST** install these before cloning and launching Neovim. Missing dependencies will cause Lazy.nvim, Mason, or plugins to fail.

**Required (Install ALL of these first):**
- **Neovim 0.9.0+** - Check version with `nvim --version`
- **Git** - Version control system
- **Node.js & npm** - Required for LSP servers (especially TypeScript)
- **Python 3** - Required for some LSP servers
- **Rust/Cargo** - Required for blink.cmp compilation
- **C Compiler** - Required for Tree-sitter compilation
  - Linux: `gcc` or `clang` (via build-essential)
  - macOS: Xcode Command Line Tools
  - Windows: Visual Studio Build Tools (Desktop development with C++)
- **ripgrep** - Required for Telescope search
- **curl/wget** - Required for Mason to download LSP servers
- **unzip, tar, gzip** - Required for Mason to extract packages
  - Linux/macOS: Usually pre-installed
  - Windows: Install 7zip
- **A Nerd Font** - Required for icons (see installation below)

**Optional but recommended:**
- **fd** - Alternative to find (faster file searching)

---

### Linux / macOS

<details>
<summary><b>Install Dependencies (click to expand)</b></summary>

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt install -y \
  neovim git build-essential ripgrep fd-find nodejs npm \
  curl wget unzip tar gzip python3 python3-pip

# Install Rust via rustup (nightly required for blink.cmp SIMD)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
rustup install nightly
```

**Arch Linux:**
```bash
sudo pacman -Syu --needed \
  neovim git base-devel ripgrep fd nodejs npm \
  curl wget unzip tar gzip python python-pip rustup

# Set up Rust toolchains (nightly required for blink.cmp SIMD)
rustup default stable
rustup install nightly

# Install yay (AUR helper) if not already installed
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si

# Install win32yank for clipboard support (required for WSL/Windows clipboard integration)
yay -S win32yank
```

**Fedora/RHEL:**
```bash
sudo dnf install -y \
  neovim git gcc make ripgrep fd-find nodejs npm \
  curl wget unzip tar gzip python3 python3-pip

# Install Rust via rustup (nightly required for blink.cmp SIMD)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
rustup install nightly
```

**macOS (Homebrew):**
```bash
brew install neovim git ripgrep fd node curl wget python3 rustup-init

# Initialize rustup and install nightly (required for blink.cmp SIMD)
rustup-init -y
source "$HOME/.cargo/env"
rustup install nightly
```

**Install Nerd Font:**
- Download from https://www.nerdfonts.com/
- Recommended: JetBrainsMono Nerd Font or FiraCode Nerd Font
- Configure your terminal to use the font

</details>

**Pre-Flight Checklist (CRITICAL - Do this BEFORE installing):**

Before proceeding, verify ALL dependencies are installed:

```bash
# Run each command and verify output
nvim --version      # Must show 0.9.0 or higher
git --version       # Any recent version
node --version      # Must show v18.0.0 or higher
npm --version       # Should be installed with Node.js
rustc --version     # Must show version (Rust compiler)
cargo --version     # Must show version (Rust package manager)
gcc --version       # C compiler (or clang --version on macOS)
python3 --version   # Must show 3.10 or higher
rg --version        # ripgrep
curl --version      # or wget --version
unzip -v            # Should show version (or 7z on Windows)
```

If ANY command fails or shows wrong version, **STOP** and install/update it first.

**Install Modulus-nvim:**

```bash
# 1. Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null
mv ~/.cache/nvim ~/.cache/nvim.backup 2>/dev/null

# 2. Clone this repository
git clone https://github.com/EvanusModestus/modulus-nvim.git ~/.config/nvim

# 3. Launch Neovim (plugins will auto-install on first launch)
nvim
```

**On first launch:**
- Lazy.nvim will automatically install plugins (takes 1-3 minutes)
- Wait for all plugins to finish installing
- If you see errors, check [Troubleshooting](#troubleshooting) below

That's it! Continue to [Post-Install Setup](#post-install-setup).

---

### Windows

> **Choose ONE package manager below.** Both work - use whichever you prefer.

<details>
<summary><b>📦 Option 1: Using winget (Recommended - Built into Windows 10/11)</b></summary>

**PowerShell (run as Administrator):**

```powershell
# Install all dependencies via winget
winget install -e --id Neovim.Neovim
winget install -e --id Git.Git
winget install -e --id BurntSushi.ripgrep.MSVC
winget install -e --id sharkdp.fd
winget install -e --id OpenJS.NodeJS
winget install -e --id Python.Python.3.12
winget install -e --id Rustlang.Rustup
winget install -e --id Microsoft.VisualStudio.2022.BuildTools
winget install -e --id 7zip.7zip

# After Visual Studio Build Tools installs, select "Desktop development with C++" workload

# Install Rust nightly (required for blink.cmp SIMD)
rustup install nightly
```

**Install Nerd Font:**
- Download from https://www.nerdfonts.com/ (JetBrainsMono or FiraCode recommended)
- Extract and install fonts (right-click `.ttf` files → Install)
- Configure Windows Terminal: Settings → Profiles → Defaults → Appearance → Font face

**Verify installations:**
```powershell
nvim --version    # Should show 0.9.0+
git --version
node --version    # Should show v18+
npm --version
rg --version
python --version  # Should show 3.10+
```

</details>

<details>
<summary><b>📦 Option 2: Using Chocolatey</b></summary>

**PowerShell (run as Administrator):**

```powershell
# Install Chocolatey if not already installed
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install all dependencies
choco install -y neovim git ripgrep fd nodejs python rustup curl wget unzip 7zip visualstudio2022buildtools

# Install Rust nightly (required for blink.cmp SIMD)
rustup install nightly
```

**Install Nerd Font:**
- Download from https://www.nerdfonts.com/
- Install the font (double-click `.ttf` files)
- Configure Windows Terminal or your terminal to use the font

**Verify installations:**
```powershell
nvim --version    # Should show 0.9.0+
git --version
node --version    # Should show v18+
npm --version
rg --version
python --version  # Should show 3.10+
```

</details>

**Pre-Flight Checklist (CRITICAL - Do this BEFORE installing):**

Before proceeding, verify ALL dependencies are installed:

```powershell
# Close and reopen PowerShell after installation, then run:
nvim --version      # Must show 0.9.0 or higher
git --version       # Any recent version
node --version      # Must show v18.0.0 or higher
npm --version       # Should be installed with Node.js
rustc --version     # Must show version
cargo --version     # Must show version
python --version    # Must show 3.10 or higher
rg --version        # ripgrep
curl --version      # Should show version
7z                  # Should show 7-Zip help
```

If ANY command fails or shows wrong version, **STOP** and install/update it first.

**Install Modulus-nvim:**

```powershell
# 1. Backup existing config (if any)
Move-Item -Path "$env:LOCALAPPDATA\nvim" -Destination "$env:LOCALAPPDATA\nvim.backup" -ErrorAction SilentlyContinue
Move-Item -Path "$env:LOCALAPPDATA\nvim-data" -Destination "$env:LOCALAPPDATA\nvim-data.backup" -ErrorAction SilentlyContinue

# 2. Clone this repository
git clone https://github.com/EvanusModestus/modulus-nvim.git $env:LOCALAPPDATA\nvim

# 3. Launch Neovim (plugins will auto-install on first launch)
nvim
```

**On first launch:**
- Lazy.nvim will automatically install plugins (takes 1-3 minutes)
- Wait for all plugins to finish installing
- If you see errors, check [Troubleshooting](#troubleshooting) below

That's it! Continue to [Post-Install Setup](#post-install-setup).

---

### WSL (Windows Subsystem for Linux)

**Install WSL first:**
```powershell
# PowerShell as Administrator
wsl --install
# Restart your computer when prompted
```

After restart and WSL setup, follow the **[Linux / macOS](#linux--macos)** instructions above using your chosen distribution (Ubuntu recommended).

**Important**: Install Nerd Font on Windows (the host), then configure Windows Terminal to use it. See detailed WSL setup in [INSTALLATION.md](INSTALLATION.md#wsl-windows-subsystem-for-linux).

---

### Post-Install Setup

After first launch, install language support:

```vim
" 1. Install Tree-sitter parsers for syntax highlighting
:TSInstall all

" 2. Install language servers (opens Mason UI)
:Mason
```

**In Mason:** Press `/` to search, `i` to install, `q` to quit.

**Recommended servers:**
- Lua: `lua-language-server`
- Python: `pyright`
- JavaScript/TypeScript: `typescript-language-server`
- Go: `gopls`
- Rust: `rust-analyzer`

**Verify everything works:**
```vim
:checkhealth
```

For detailed troubleshooting, see **[INSTALLATION.md](INSTALLATION.md)**.

## Modular Architecture

```
modulus-nvim/
├── init.lua                    # Entry point
├── lua/evanusmodestus/
│   ├── init.lua                # Module initialization
│   ├── lazy-plugins.lua        # Plugin specifications
│   └── modules/
│       ├── core/               # Core editor settings
│       │   ├── settings.lua    # Neovim options
│       │   ├── keymaps.lua     # Core keybindings
│       │   ├── plugin-keymaps.lua  # Plugin keybindings
│       │   ├── compile-keymaps.lua # Keymap compilation
│       │   └── autocmds.lua    # Autocommands
│       ├── plugins/            # 27+ plugin configs
│       │   ├── telescope.lua   # Fuzzy finder
│       │   ├── treesitter.lua  # Syntax parsing
│       │   ├── blink-cmp.lua   # Completion
│       │   ├── oil.lua         # File manager
│       │   ├── harpoon.lua     # Quick navigation
│       │   └── ...             # And more!
│       ├── lsp/                # LSP configuration
│       │   ├── init.lua        # LSP setup
│       │   └── debug.lua       # LSP debugging
│       └── ui/                 # UI enhancements
│           ├── colorscheme.lua # Theme config
│           ├── lualine.lua     # Status line
│           └── visual-enhancements.lua
```

## Documentation

- **[INSTALLATION.md](INSTALLATION.md)** - Comprehensive setup guide
- **[KEYMAP_REFERENCE.md](KEYMAP_REFERENCE.md)** - Complete keymap reference
- **[LSP_CONFIGURATION.md](LSP_CONFIGURATION.md)** - LSP setup and troubleshooting
- **[CONFIGURATION_SUMMARY.md](CONFIGURATION_SUMMARY.md)** - Quick configuration reference

## Essential Keybindings

### Leader Key: `<Space>`

#### File Navigation
- `<leader>pf` - Find files (Telescope)
- `<leader>ps` - Grep search project
- `<leader>pv` - File explorer (Oil.nvim)

#### LSP
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>vca` - Code actions
- `<leader>vrn` - Rename symbol

#### Git
- `<leader>gs` - Git status
- `<leader>gd` - Git diff

For complete keybindings, see **[KEYMAP_REFERENCE.md](KEYMAP_REFERENCE.md)**.

## Customization

### Optional: Obsidian Integration

Modulus includes optional Obsidian vault integration for knowledge management. To use:

1. Edit `lua/evanusmodestus/modules/plugins/obsidian-capture.lua`
2. Update the `vault_path` (line 26) to point to your Obsidian vault
3. Customize the `paths` structure to match your vault layout

If you don't use Obsidian, the plugin will gracefully disable itself—no action needed!

### Adding Your Own Plugins

Edit `lua/evanusmodestus/lazy-plugins.lua` and add your plugin specification:
```lua
{
    'author/plugin-name',
    config = function()
        require('plugin-name').setup({})
    end
}
```

## Requirements

- Neovim 0.9.0 or higher
- Git
- A Nerd Font (for icons)
- ripgrep (for Telescope grep)
- Node.js (for certain LSP servers)
- C compiler (for Tree-sitter)

See **[INSTALLATION.md](INSTALLATION.md)** for platform-specific requirements.

## Philosophy

Modulus is built on these principles:

1. **Modularity First**: Every feature is self-contained and optional
2. **Clarity Over Cleverness**: Code should be readable and educational
3. **Sensible Defaults**: Works great out of the box, easy to customize
4. **Cross-Platform**: One config, all platforms
5. **Performance Matters**: Fast startup, responsive completion

## Plugin Count

27+ carefully selected and configured plugins, including:
- Telescope, Tree-sitter, LSP, Mason
- Blink.cmp (completion), Harpoon (navigation)
- Fugitive, Gitsigns (Git integration)
- DAP (debugging), Toggleterm (terminals)
- And many more productivity enhancers!

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes with clear commit messages
4. Test on multiple platforms if possible
5. Submit a pull request

## License

This configuration is provided as-is for personal use and learning purposes.

## Acknowledgments

Built with inspiration from the Neovim community and countless contributors to the plugins included in this configuration.

---

**Ready to get started?** Check out the **[INSTALLATION.md](INSTALLATION.md)** guide!
