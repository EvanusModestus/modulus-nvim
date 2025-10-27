# Modulus-nvim

> A truly modular Neovim configuration built for clarity, flexibility, and performance

Modulus is a comprehensive, production-ready Neovim configuration designed with modularity at its core. It provides a complete IDE experience while remaining transparent and easy to understand—perfect for both daily use and learning how to build your own configuration.

## ✨ Why Modulus?

- **🧩 Truly Modular**: Clean separation of concerns with organized module structure
- **🚀 Production Ready**: Battle-tested features for professional development workflows
- **⚡ Fast**: Ultra-fast completion with blink.cmp (Rust-powered SIMD fuzzy matching)
- **🌍 Cross-Platform**: Works seamlessly on Windows, Linux, macOS, and WSL
- **📚 Well-Documented**: Every feature explained with extensive documentation
- **🎓 Learning-Friendly**: Code is clear, commented, and educational

## 🎯 Key Features

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

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/EvanusModestus/modulus-nvim.git ~/.config/nvim

# Launch Neovim (plugins will auto-install)
nvim

# Install language servers
:Mason
```

For detailed installation instructions, see **[INSTALLATION.md](INSTALLATION.md)**.

## 📁 Modular Architecture

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

## 📖 Documentation

- **[INSTALLATION.md](INSTALLATION.md)** - Comprehensive setup guide
- **[KEYMAP_REFERENCE.md](KEYMAP_REFERENCE.md)** - Complete keymap reference
- **[LSP_CONFIGURATION.md](LSP_CONFIGURATION.md)** - LSP setup and troubleshooting
- **[CONFIGURATION_SUMMARY.md](CONFIGURATION_SUMMARY.md)** - Quick configuration reference

## ⌨️ Essential Keybindings

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

## 🔧 Customization

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

## 🛠️ Requirements

- Neovim 0.9.0 or higher
- Git
- A Nerd Font (for icons)
- ripgrep (for Telescope grep)
- Node.js (for certain LSP servers)
- C compiler (for Tree-sitter)

See **[INSTALLATION.md](INSTALLATION.md)** for platform-specific requirements.

## 🎯 Philosophy

Modulus is built on these principles:

1. **Modularity First**: Every feature is self-contained and optional
2. **Clarity Over Cleverness**: Code should be readable and educational
3. **Sensible Defaults**: Works great out of the box, easy to customize
4. **Cross-Platform**: One config, all platforms
5. **Performance Matters**: Fast startup, responsive completion

## 📊 Plugin Count

27+ carefully selected and configured plugins, including:
- Telescope, Tree-sitter, LSP, Mason
- Blink.cmp (completion), Harpoon (navigation)
- Fugitive, Gitsigns (Git integration)
- DAP (debugging), Toggleterm (terminals)
- And many more productivity enhancers!

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes with clear commit messages
4. Test on multiple platforms if possible
5. Submit a pull request

## 📄 License

This configuration is provided as-is for personal use and learning purposes.

## 🙏 Acknowledgments

Built with inspiration from the Neovim community and countless contributors to the plugins included in this configuration.

---

**Ready to get started?** Check out the **[INSTALLATION.md](INSTALLATION.md)** guide!
