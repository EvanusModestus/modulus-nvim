# 🗺️ Neovim Keymap Reference

> **Quick Discovery**: Use `:Telescope keymaps` to search all mappings interactively!

## 📂 **Core Navigation & Editing**

### File Operations
| Key | Action | Source |
|-----|---------|---------|
| `<leader>pf` | Project Find Files | plugin-keymaps.lua |
| `<C-p>` | Git Files | plugin-keymaps.lua |
| `<leader>/` | Live Grep | plugin-keymaps.lua |
| `<leader>?` | Current Buffer Search | plugin-keymaps.lua |

### Buffers & Windows
| Key | Action | Source |
|-----|---------|---------|
| `<leader>pb` | Project Buffers | plugin-keymaps.lua |
| `<leader>po` | Recent Files (oldfiles) | plugin-keymaps.lua |

### Search & Help
| Key | Action | Source |
|-----|---------|---------|
| `<leader>ps` | Project Search (with prompt) | plugin-keymaps.lua |
| `<leader>vh` | Vim Help Tags | plugin-keymaps.lua |

### File Manager (oil.nvim)
| Key | Action | Source |
|-----|---------|---------|
| `<leader>e` | Open parent directory | oil.lua |
| `g.` | Toggle hidden files | oil.nvim |
| `g?` | Show help | oil.nvim |
| `-` | Go to parent directory | oil.nvim |
| `<CR>` | Open file/save changes | oil.nvim |

## 🎯 **Harpoon (Quick File Navigation)**
| Key | Action | Source |
|-----|---------|---------|
| `<leader>a` | Add to Harpoon | plugin-keymaps.lua |
| `<C-e>` | Harpoon Menu | plugin-keymaps.lua |
| `<C-h>` | Harpoon File 1 | plugin-keymaps.lua |
| `<C-t>` | Harpoon File 2 | plugin-keymaps.lua |
| `<C-n>` | Harpoon File 3 | plugin-keymaps.lua |
| `<C-s>` | Harpoon File 4 | plugin-keymaps.lua |

## 📝 **Git Operations**
| Key | Action | Source |
|-----|---------|---------|
| `<leader>gs` | Git Status | plugin-keymaps.lua |
| `<leader>gp` | Git Push | plugin-keymaps.lua |
| `<leader>gP` | Git Pull Rebase | plugin-keymaps.lua |
| `<leader>lg` | LazyGit | plugin-keymaps.lua |

## 🛠️ **Development Tools**

### LSP (Language Server Protocol)
| Key | Action | Source |
|-----|---------|---------|
| **Navigation** |
| `gd` | Go to Definition | lsp/init.lua |
| `gD` | Go to Declaration | lsp/init.lua |
| `gi` | Go to Implementation | lsp/init.lua |
| `go` | Go to Type Definition | lsp/init.lua |
| `<leader>vrr` | Find References | lsp/init.lua |
| **Information** |
| `K` | Hover Documentation | lsp/init.lua |
| `<C-h>` | Signature Help (Insert mode) | lsp/init.lua |
| **Diagnostics** |
| `<leader>vd` | Show Diagnostic Float | lsp/init.lua |
| `[d` | Previous Diagnostic | lsp/init.lua |
| `]d` | Next Diagnostic | lsp/init.lua |
| `<leader>vq` | Diagnostics to Quickfix | lsp/init.lua |
| **Actions** |
| `<leader>vca` | Code Action | lsp/init.lua |
| `<leader>vrn` | Rename Symbol | lsp/init.lua |
| `<leader>vws` | Workspace Symbol Search | lsp/init.lua |
| `<leader>vf` | Format Buffer | lsp/init.lua |
| `<leader>vh` | Toggle Inlay Hints | lsp/init.lua |

### Completion (blink.cmp)
| Key | Action | Mode | Source |
|-----|---------|------|---------|
| `<C-Space>` | Show/Hide Completions | Insert | blink-cmp.lua |
| `<Tab>` | Accept Completion | Insert | blink-cmp.lua |
| `<CR>` | Accept Completion | Insert | blink-cmp.lua |
| `<C-n>` | Next Completion | Insert | blink-cmp.lua |
| `<C-p>` | Previous Completion | Insert | blink-cmp.lua |
| `<Down>` | Next Completion | Insert | blink-cmp.lua |
| `<Up>` | Previous Completion | Insert | blink-cmp.lua |
| `<C-e>` | Hide Completions | Insert | blink-cmp.lua |
| `<C-b>` | Scroll Docs Up | Insert | blink-cmp.lua |
| `<C-f>` | Scroll Docs Down | Insert | blink-cmp.lua |

### Debugging (DAP)
| Key | Action | Source |
|-----|---------|---------|
| `<F5>` | Debug Continue | plugin-keymaps.lua |
| `<F10>` | Step Over | plugin-keymaps.lua |
| `<F11>` | Step Into | plugin-keymaps.lua |
| `<F12>` | Step Out | plugin-keymaps.lua |
| `<leader>b` | Toggle Breakpoint | plugin-keymaps.lua |
| `<leader>B` | Conditional Breakpoint | plugin-keymaps.lua |
| `<leader>du` | Toggle Debug UI | plugin-keymaps.lua |

### Refactoring
| Key | Action | Mode | Source |
|-----|---------|------|---------|
| `<leader>re` | Extract | Visual | plugin-keymaps.lua |
| `<leader>rf` | Extract to File | Visual | plugin-keymaps.lua |
| `<leader>rv` | Extract Variable | Visual | plugin-keymaps.lua |
| `<leader>ri` | Inline Variable | Normal/Visual | plugin-keymaps.lua |

### Compilation & Running
| Key | Action | Source |
|-----|---------|---------|
| `<leader>cr` | Compile & Run | compile-keymaps.lua |
| `<leader>cc` | Compile Only | compile-keymaps.lua |

## 🧘 **Productivity & Focus**
| Key | Action | Source |
|-----|---------|---------|
| `<leader>u` | Toggle Undotree | plugin-keymaps.lua |
| `<leader>zz` | Zen Mode | plugin-keymaps.lua |
| `<leader>mr` | Make It Rain! | plugin-keymaps.lua |

## 💻 **Terminal & External Tools**
| Key | Action | Source |
|-----|---------|---------|
| `<leader>tt` | Toggle Terminal | plugin-keymaps.lua |
| `<leader>tf` | Float Terminal | plugin-keymaps.lua |
| `<leader>th` | Horizontal Terminal | plugin-keymaps.lua |
| `<leader>tv` | Vertical Terminal | plugin-keymaps.lua |

## 📄 **Documentation & Preview**
| Key | Action | Source |
|-----|---------|---------|
| `<leader>mp` | Markdown Preview | plugin-keymaps.lua |
| `<leader>mg` | Glow Preview | plugin-keymaps.lua |

## 🗄️ **Database**
| Key | Action | Source |
|-----|---------|---------|
| `<leader>db` | Database UI | plugin-keymaps.lua |

## 🔍 **Discovery Commands**
```vim
:Telescope keymaps    " Interactive keymap search
:map <leader>         " Show all leader mappings
:WhichKey             " If installed, shows key hints
:nmap <leader>p       " Show all <leader>p* mappings
:help key-notation    " Key syntax help
```

## 📁 **Source Files**
- **Core**: `lua/evanusmodestus/modules/core/keymaps.lua`
- **Plugin**: `lua/evanusmodestus/modules/core/plugin-keymaps.lua`
- **Compile**: `lua/evanusmodestus/modules/core/compile-keymaps.lua`
- **Individual plugins**: `lua/evanusmodestus/modules/plugins/*.lua`

---
*💡 Pro tip: Use `:Telescope keymaps` and type what you're looking for!*