# Installation Guide for Modulus-nvim

> **CRITICAL: Read This First!**
>
> **Many installation failures happen because users skip prerequisite installation.**
>
> This guide is structured to prevent common issues:
> 1. Install ALL prerequisites FIRST (don't skip!)
> 2. Verify installations with version checks
> 3. Only then clone and launch Neovim
>
> **Following this order prevents 90% of installation issues.**

---

## Tested Platforms

This configuration has been tested and verified on:

- **Ubuntu 22.04 / 24.04** (tested)
- **Arch Linux** (tested)
- **Fedora** (tested)
- **macOS** (Ventura+)
- **Windows 10/11** (native + WSL 2)

## Quick Start Checklist

**Before doing ANYTHING else, complete these steps in order:**

- [ ] **Step 1:** Install Neovim 0.9.0+ (`nvim --version` to verify)
- [ ] **Step 2:** Install Git (`git --version` to verify)
- [ ] **Step 3:** Install Node.js 18+ (`node --version` to verify)
- [ ] **Step 4:** Install ripgrep (`rg --version` to verify)
- [ ] **Step 5:** Install Rust/Cargo (`rustc --version` and `cargo --version` to verify)
- [ ] **Step 6:** Install C compiler (gcc/clang/MSVC)
- [ ] **Step 7:** Install Python 3.10+ (`python --version` to verify)
- [ ] **Step 8:** Install curl/wget and unzip/tar/7zip
- [ ] **Step 9:** Install a Nerd Font and configure your terminal
- [ ] **Step 10:** Run ALL version check commands - if ANY fail, STOP and fix
- [ ] **Step 11:** Clone the repository
- [ ] **Step 12:** Launch Neovim and wait for plugins to install

**If you skip prerequisites or don't verify versions, you WILL encounter errors.**

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation by Platform](#installation-by-platform)
  - [Linux/macOS](#linuxmacos)
  - [Windows](#windows)
  - [WSL (Windows Subsystem for Linux)](#wsl-windows-subsystem-for-linux)
- [Post-Installation Steps](#post-installation-steps)
- [Troubleshooting](#troubleshooting)
- [Updating](#updating)
- [Uninstallation](#uninstallation)

## Prerequisites

### Installing All Dependencies

#### Ubuntu/Debian

```bash
# Install all required dependencies
sudo apt update && sudo apt install -y \
  neovim \
  git \
  build-essential \
  ripgrep \
  fd-find \
  nodejs \
  npm \
  curl \
  unzip \
  tar \
  gzip \
  python3 \
  python3-pip \
  python3-venv \
  wget

# Install Rust (required for blink.cmp)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# Install glow (optional - markdown viewer)
wget https://github.com/charmbracelet/glow/releases/download/v1.5.1/glow_1.5.1_linux_amd64.tar.gz
tar -xzf glow_1.5.1_linux_amd64.tar.gz
sudo mv glow /usr/local/bin/
rm glow_1.5.1_linux_amd64.tar.gz
```

Verify Neovim version (must be 0.9.0+):
```bash
nvim --version

# If Neovim is too old, install from snap or PPA:
# Option 1: Snap (recommended)
sudo snap install nvim --classic

# Option 2: PPA
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim
```

#### Arch Linux

```bash
# Install all required dependencies
sudo pacman -Syu --needed \
  neovim \
  git \
  base-devel \
  ripgrep \
  fd \
  nodejs \
  npm \
  curl \
  wget \
  unzip \
  tar \
  gzip \
  python \
  python-pip \
  rust

# Cargo is included with rust package on Arch

# Install glow (optional - markdown viewer)
# Option 1: From AUR
yay -S glow
# Or using paru
paru -S glow

# Option 2: Manual installation
wget https://github.com/charmbracelet/glow/releases/download/v1.5.1/glow_1.5.1_linux_amd64.tar.gz
tar -xzf glow_1.5.1_linux_amd64.tar.gz
sudo mv glow /usr/local/bin/
rm glow_1.5.1_linux_amd64.tar.gz
```

**Note**: Arch typically has latest Neovim in official repos. If you need bleeding edge:
```bash
# Install from git (optional)
yay -S neovim-git
```

#### Fedora/RHEL

```bash
sudo dnf install -y \
  neovim \
  git \
  gcc \
  make \
  ripgrep \
  fd-find \
  nodejs \
  npm \
  curl \
  unzip \
  tar \
  gzip \
  python3 \
  python3-pip \
  wget

# Install Rust (required for blink.cmp)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# Install glow (optional - markdown viewer)
wget https://github.com/charmbracelet/glow/releases/download/v1.5.1/glow_1.5.1_linux_amd64.tar.gz
tar -xzf glow_1.5.1_linux_amd64.tar.gz
sudo mv glow /usr/local/bin/
rm glow_1.5.1_linux_amd64.tar.gz
```

#### macOS

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install neovim git ripgrep fd node curl wget python3 rust glow
```

#### Windows

> **CRITICAL:** You MUST install these dependencies BEFORE cloning the config and launching Neovim.

**Option 1: Using winget (Recommended - Built into Windows 10/11)**

```powershell
# PowerShell as Administrator
winget install -e --id Neovim.Neovim
winget install -e --id Git.Git
winget install -e --id BurntSushi.ripgrep.MSVC
winget install -e --id sharkdp.fd
winget install -e --id OpenJS.NodeJS
winget install -e --id Python.Python.3.12
winget install -e --id Rustlang.Rust.MSVC
winget install -e --id Microsoft.VisualStudio.2022.BuildTools
winget install -e --id 7zip.7zip

# After Visual Studio Build Tools installs:
# 1. Launch "Visual Studio Installer"
# 2. Click "Modify" on Build Tools
# 3. Select "Desktop development with C++"
# 4. Click "Install"
```

**Option 2: Using Chocolatey**

```powershell
# Install Chocolatey if not already installed
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install dependencies
choco install -y neovim git ripgrep fd nodejs python rust curl wget unzip 7zip

# Install Visual Studio Build Tools for C compilation
choco install -y visualstudio2022buildtools --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools"
```

**Verify ALL installations (CRITICAL STEP):**

```powershell
# Close and reopen PowerShell, then run:
nvim --version      # Must show 0.9.0+
git --version
node --version      # Must show v18.0.0+
npm --version
rg --version
python --version    # Must show 3.10+
```

**If ANY command fails, DO NOT proceed. Fix the installation first.**

### Additional Requirements

#### Nerd Font (Required for icons)
- Download from [Nerd Fonts](https://www.nerdfonts.com/)
- Recommended: JetBrainsMono Nerd Font, FiraCode Nerd Font, or Hack Nerd Font
- Install the font and configure your terminal to use it
- **Note**: Font is installed on your local machine, not the remote server if using SSH

---

## Installation by Platform

### Linux/macOS

1. **Backup existing Neovim configuration (if any)**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   mv ~/.local/state/nvim ~/.local/state/nvim.backup
   mv ~/.cache/nvim ~/.cache/nvim.backup
   ```

2. **Clone the repository**
   ```bash
   git clone https://github.com/EvanusModestus/modulus-nvim.git ~/.config/nvim
   ```

3. **Launch Neovim**
   ```bash
   nvim
   ```

   Lazy.nvim will automatically install all plugins on first launch. This may take a few minutes.

4. **Continue to [Post-Installation Steps](#post-installation-steps)**

---

### Windows

#### Option 1: Direct Clone (Recommended)

1. **Backup existing Neovim configuration (if any)**
   ```powershell
   Move-Item -Path "$env:LOCALAPPDATA\nvim" -Destination "$env:LOCALAPPDATA\nvim.backup" -ErrorAction SilentlyContinue
   Move-Item -Path "$env:LOCALAPPDATA\nvim-data" -Destination "$env:LOCALAPPDATA\nvim-data.backup" -ErrorAction SilentlyContinue
   ```

2. **Clone the repository directly to the Neovim config location**
   ```powershell
   git clone https://github.com/EvanusModestus/modulus-nvim.git $env:LOCALAPPDATA\nvim
   ```

3. **Launch Neovim**
   ```powershell
   nvim
   ```

   Lazy.nvim will automatically install all plugins.

4. **Continue to [Post-Installation Steps](#post-installation-steps)**

#### Option 2: Clone with Junction Link

This method allows you to keep the config in a custom location while Neovim reads it from the standard location.

1. **Clone to a custom location**
   ```powershell
   cd C:\Users\$env:USERNAME
   git clone https://github.com/EvanusModestus/modulus-nvim.git modulus-nvim
   ```

2. **Create a junction (not a symlink)**
   ```powershell
   New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "C:\Users\$env:USERNAME\modulus-nvim"
   ```

3. **Launch Neovim**
   ```powershell
   nvim
   ```

4. **Continue to [Post-Installation Steps](#post-installation-steps)**

> **Note**: Use a junction, not a symbolic link. Junctions don't require administrator privileges and work reliably with Neovim on Windows.

---

### WSL (Windows Subsystem for Linux)

WSL provides a full Linux environment on Windows. Recommended for developers who prefer Linux tools.

#### Step 1: Install WSL

**PowerShell (Administrator):**

```powershell
# Install WSL with default Ubuntu distribution
wsl --install

# Or install specific distribution:
# wsl --install -d Ubuntu-22.04
# wsl --install -d Debian
# wsl --install -d Fedora-Remix-for-WSL
```

**Available distributions:**
```powershell
# List available distributions
wsl --list --online

# Popular choices for this config:
# - Ubuntu-22.04 (recommended - tested)
# - Ubuntu (latest)
# - Debian
# - Fedora-Remix-for-WSL
```

**Restart your computer** after WSL installation completes.

#### Step 2: First Launch and Setup

After restart, launch your Linux distribution from the Start menu. You'll be prompted to:
1. Create a username (lowercase, no spaces)
2. Create a password

#### Step 3: Update System

Once inside your WSL distribution, update the package manager:

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt upgrade -y
```

**Fedora:**
```bash
sudo dnf update -y
```

#### Step 4: Install Dependencies

Choose your distribution and follow the installation commands from the [Prerequisites](#installing-all-dependencies) section above:

- **Ubuntu/Debian** → Use [Ubuntu/Debian instructions](#ubuntudebian)
- **Arch** → Use [Arch Linux instructions](#arch-linux) (if using Arch WSL)
- **Fedora** → Use [Fedora/RHEL instructions](#fedorarhel)

#### Step 5: Install Modulus-nvim

```bash
# 1. Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null

# 2. Clone repository
git clone https://github.com/EvanusModestus/modulus-nvim.git ~/.config/nvim

# 3. Launch Neovim
nvim
```

#### WSL-Specific Notes

**Fonts:**
- Nerd Fonts must be installed on Windows (the host), not in WSL
- Configure Windows Terminal to use the Nerd Font
- Settings → Profiles → Ubuntu (or your distro) → Appearance → Font face

**Clipboard:**
- Clipboard sharing works automatically with WSL 2
- Use `"+y` to yank to Windows clipboard from Neovim
- Use `"+p` to paste from Windows clipboard

**File Access:**
- Access Windows files from WSL: `/mnt/c/Users/YourName/`
- Access WSL files from Windows: `\\wsl$\Ubuntu\home\username\`
- **Best practice**: Keep projects in Linux filesystem for better performance

**Performance:**
- WSL 2 provides near-native Linux performance
- Store your code in WSL filesystem (not /mnt/c) for best performance
- Example: Use `~/projects/` instead of `/mnt/c/Users/YourName/projects/`

---

## Post-Installation Steps

### 1. Install Tree-sitter Parsers

After plugins have installed, install Tree-sitter language parsers:

```vim
:TSInstall all
```

Or install only the languages you need:
```vim
:TSInstall lua vim vimdoc python javascript typescript go rust bash markdown json yaml
```

### 2. Install Language Servers

Open Mason and install the language servers you need:

```vim
:Mason
```

**In the Mason UI:**
- Use `/` to search for a language server
- Press `i` to install
- Press `X` to uninstall
- Press `U` to update all installed servers

**Recommended language servers:**
- **Lua**: `lua-language-server`
- **Python**: `pyright` or `pylsp`
- **JavaScript/TypeScript**: `typescript-language-server`
- **Go**: `gopls`
- **Rust**: `rust-analyzer`
- **C/C++**: `clangd`
- **Bash**: `bash-language-server`
- **JSON**: `json-lsp`
- **YAML**: `yaml-language-server`
- **Markdown**: `marksman`

### 3. Verify Installation

Run Neovim's health check:
```vim
:checkhealth
```

This will show you any issues with your installation.

### 4. Configure Your Terminal Font

Make sure your terminal is using a Nerd Font:

- **iTerm2 (macOS)**: Preferences → Profiles → Text → Font
- **Windows Terminal**: Settings → Profiles → Appearance → Font face
- **Alacritty**: Edit `~/.config/alacritty/alacritty.yml`
- **Kitty**: Edit `~/.config/kitty/kitty.conf`

### 5. Optional: Obsidian Integration

If you use Obsidian for note-taking:

1. Open the Obsidian capture plugin:
   ```bash
   nvim ~/.config/nvim/lua/evanusmodestus/modules/plugins/obsidian-capture.lua
   ```

2. Update line 26 with your vault path:
   ```lua
   vault_path = vim.fn.expand('~/path/to/your/vault'),
   ```

3. Customize the `paths` table to match your vault's folder structure

If you don't use Obsidian, the plugin will automatically disable itself—no action needed!

---

## Troubleshooting

### Common Installation Issues

> **First step for ANY issue:** Run `:checkhealth` in Neovim to identify problems

#### Issue: Plugins Not Installing on First Launch

**Symptoms:** Lazy.nvim window shows errors, plugins fail to install

**Solutions:**
1. **Check Neovim version:** `nvim --version` (must be 0.9.0+)
2. **Verify Git is installed:** `git --version`
3. **Check internet connection:** Lazy.nvim needs to download plugins
4. **Manually trigger installation:** Open Neovim and run `:Lazy sync`
5. **Check for errors:** `:Lazy log` shows detailed error messages
6. **Last resort - Clear cache and reinstall:**
   ```bash
   # Linux/macOS
   rm -rf ~/.local/share/nvim
   rm -rf ~/.local/state/nvim
   rm -rf ~/.cache/nvim
   # Then launch nvim again

   # Windows
   Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-data
   Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-state
   # Then launch nvim again
   ```

#### Issue: typescript-language-server Fails to Install via Mason

**Symptoms:** Mason shows "typescript-language-server" installation failed

**Root Cause:** Node.js is not installed or not in PATH

**Solutions:**
1. **Verify Node.js is installed:**
   ```bash
   node --version    # Must show v18.0.0 or higher
   npm --version
   ```

2. **If Node.js not found:**
   - **Windows:** Install via `winget install -e --id OpenJS.NodeJS` or `choco install nodejs`
   - **Linux:** `sudo apt install nodejs npm` (Ubuntu) or `sudo dnf install nodejs` (Fedora)
   - **macOS:** `brew install node`

3. **Close and reopen Neovim** after installing Node.js

4. **Manually install in Mason:**
   ```vim
   :Mason
   # Press / to search for "typescript-language-server"
   # Press i to install
   ```

#### Issue: blink.cmp Shows Errors or Doesn't Work

**Symptoms:** Completion not working, errors about blink.cmp

**Root Causes & Solutions:**

1. **Missing Rust/Cargo:**
   - blink.cmp requires Rust to build
   - Verify Rust is installed:
     ```bash
     rustc --version
     cargo --version
     ```
   - If missing, install Rust:
     ```bash
     # Linux/macOS/WSL
     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
     source "$HOME/.cargo/env"

     # Windows
     winget install -e --id Rustlang.Rust.MSVC
     ```
   - After installing, rebuild blink.cmp:
     ```vim
     :Lazy build blink.cmp
     ```

2. **Conflicting completion plugin:**
   - If you previously used nvim-cmp, clear its cache:
     ```bash
     rm -rf ~/.local/share/nvim/site/pack/packer  # Linux/macOS
     ```

3. **Check blink.cmp status:**
   ```vim
   :lua print(vim.inspect(require('blink.cmp')))
   ```

#### Issue: Harpoon Keybindings Don't Work

**Symptoms:** `<leader>a` or `<C-e>` don't add files or show menu

**Solutions:**
1. **Check if Harpoon is loaded:**
   ```vim
   :lua print(vim.inspect(package.loaded['harpoon']))
   ```

2. **Check for keymap conflicts:**
   ```vim
   :verbose nmap <leader>a
   :verbose nmap <C-e>
   ```

3. **Manually trigger Harpoon:**
   ```vim
   :lua require("harpoon.mark").add_file()
   :lua require("harpoon.ui").toggle_quick_menu()
   ```

4. **Verify Harpoon is installed:**
   ```vim
   :Lazy
   # Search for "harpoon", should show as installed
   ```

### Tree-sitter Compilation Errors

**Issue**: Tree-sitter parsers fail to compile

**Solutions**:

**Linux**:
```bash
# Debian/Ubuntu
sudo apt install build-essential

# Fedora
sudo dnf install gcc make
```

**macOS**:
```bash
xcode-select --install
```

**Windows**:
- Install Visual Studio Build Tools from Microsoft
- Or install MinGW-w64 via MSYS2
- Ensure compiler is in your PATH

### LSP Not Working

**Issue**: Language server isn't providing completions or diagnostics

**Solutions**:
1. Check LSP status: `:LspInfo`
2. Verify server is installed: `:Mason`
3. Check LSP logs: `:LspLog`
4. Restart LSP: `:LspRestart`

### Mason Install Fails

**Issue**: Mason can't install language servers

**Solutions**:
1. Check you have internet connectivity
2. Verify Node.js is installed: `node --version`
3. Check Mason log: `:MasonLog`
4. Try manual installation:
   ```vim
   :MasonInstall <server-name>
   ```

### Icons Not Showing (Question Marks/Boxes)

**Issue**: You see `?` or boxes instead of icons

**Solution**:
- Install a Nerd Font (see [Prerequisites](#prerequisites))
- Configure your terminal to use the Nerd Font
- Restart your terminal

### Slow Startup

**Issue**: Neovim takes a long time to start

**Solutions**:
1. Profile startup time:
   ```bash
   nvim --startuptime startup.log
   ```
2. Disable unused plugins in `lua/evanusmodestus/lazy-plugins.lua`
3. Reduce Tree-sitter parsers (only install what you need)
4. Use lazy loading for plugins (most are already configured for this)

### Platform-Specific Issues

#### Windows-Specific

**Line Ending Issues:**
```bash
git config --global core.autocrlf true
```

**Missing 7-Zip:**
- Mason requires 7z to extract packages
- Install: `winget install -e --id 7zip.7zip`
- Or: `choco install 7zip`

**Python not found:**
- Python might not be in PATH after installation
- Verify with: `python --version`
- If fails, reinstall Python with "Add to PATH" checked

**Node.js npm permissions:**
- Some LSP servers fail to install due to npm permissions
- Run PowerShell as Administrator when installing via Mason

#### macOS-Specific

**Xcode Command Line Tools:**
- Required for C compiler (Tree-sitter)
- Install: `xcode-select --install`

**Homebrew not in PATH:**
- If commands not found after `brew install`:
  ```bash
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
  source ~/.zshrc
  ```

**fd command name conflict:**
- On macOS, `fd` might conflict with other tools
- Homebrew installs it as `fd`
- Config already handles this

#### Linux-Specific

**Old Neovim version in repos:**
- **Ubuntu/Debian**: Use snap or PPA (see [Ubuntu instructions](#ubuntudebian))
- **Fedora**: Official repos usually have recent version
- **Arch**: Always has latest stable

**fd-find vs fd:**
- Ubuntu/Debian install as `fd-find`, but symlink to `fd` works
- Arch installs as `fd` directly

**Missing build tools:**
- Ubuntu/Debian: `sudo apt install build-essential`
- Arch: `sudo pacman -S base-devel`
- Fedora: `sudo dnf groupinstall "Development Tools"`

#### WSL-Specific

**Clipboard not working:**
- Ensure you're using WSL 2 (not WSL 1)
- Check version: `wsl -l -v` in PowerShell
- Upgrade to WSL 2: `wsl --set-version Ubuntu 2`

**Slow file access:**
- Don't work from `/mnt/c/` (Windows filesystem)
- Use Linux filesystem: `~/projects/` for best performance

**Git credential storage:**
```bash
# Share Windows Git credentials with WSL
git config --global credential.helper "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe"
```

**Node.js version mismatch:**
- WSL has separate Node.js from Windows
- Install Node.js in WSL, not just on Windows

---

## Updating

### Update Configuration

```bash
cd ~/.config/nvim  # Or your install location
git pull origin main
```

### Update Plugins

Inside Neovim:
```vim
:Lazy sync
```

### Update Language Servers

```vim
:Mason
# Press U to update all installed servers
```

### Update Tree-sitter Parsers

```vim
:TSUpdate
```

---

## Uninstallation

### Linux/macOS

```bash
# Remove configuration
rm -rf ~/.config/nvim

# Remove data
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

### Windows

```powershell
# Remove configuration
Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim

# Remove data
Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-data
```

### Restore Backup

If you backed up your old config:

```bash
# Linux/macOS
mv ~/.config/nvim.backup ~/.config/nvim
mv ~/.local/share/nvim.backup ~/.local/share/nvim

# Windows
Move-Item -Path "$env:LOCALAPPDATA\nvim.backup" -Destination "$env:LOCALAPPDATA\nvim"
```

---

## Getting Help

- **Check Documentation**: See [KEYMAP_REFERENCE.md](KEYMAP_REFERENCE.md) and [LSP_CONFIGURATION.md](LSP_CONFIGURATION.md)
- **Run Health Check**: `:checkhealth` in Neovim
- **Check Plugin Status**: `:Lazy` for plugin manager UI
- **Check LSP Status**: `:LspInfo` for LSP information
- **View Logs**: `:Lazy log` for plugin logs, `:LspLog` for LSP logs

---

**Installation complete!** Check out the [KEYMAP_REFERENCE.md](KEYMAP_REFERENCE.md) to learn the essential keybindings.
