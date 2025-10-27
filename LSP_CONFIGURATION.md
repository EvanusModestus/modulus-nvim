# 🔧 LSP Configuration Guide

Complete reference for Language Server Protocol setup with enhanced completion and intelligent code assistance.

## 📋 Table of Contents

- [Overview](#overview)
- [Core Components](#core-components)
- [Language Server Setup](#language-server-setup)
- [Completion Engine](#completion-engine)
- [Keymaps Reference](#keymaps-reference)
- [Advanced Features](#advanced-features)
- [Troubleshooting](#troubleshooting)

## Overview

This configuration provides a complete LSP setup using:

- **LSP Zero**: Streamlined LSP configuration framework
- **Mason**: Language server installer and manager
- **mason-lspconfig**: Bridge between Mason and lspconfig
- **blink.cmp**: Ultra-fast Rust-powered completion engine (2-10x faster than nvim-cmp)
- **LuaSnip**: Snippet engine with extensive snippet support

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Your Neovim Buffer                   │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    blink.cmp Engine                     │
│  ┌──────────┬──────────┬──────────┬──────────────────┐  │
│  │   LSP    │ Snippets │   Path   │     Buffer       │  │
│  │ (prio100)│ (prio 80)│ (prio 50)│   (prio -50)     │  │
│  └──────────┴──────────┴──────────┴──────────────────┘  │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│              Language Server (via lspconfig)            │
│                  (lua_ls, ts_ls, etc.)                  │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                  Mason Package Manager                  │
│           (Installs & manages LSP servers)              │
└─────────────────────────────────────────────────────────┘
```

## Core Components

### 1. LSP Zero

**Purpose**: Simplifies LSP setup with sensible defaults

**Configuration**: `lua/evanusmodestus/modules/lsp/init.lua`

**Key Features**:
- Unified `on_attach` function for all language servers
- Automatic capability registration
- Consistent keymaps across all LSP-enabled buffers

### 2. Mason & mason-lspconfig

**Mason Setup**:
```lua
require('mason').setup({})
```

**mason-lspconfig v2.0+ Changes**:
> **IMPORTANT**: Version 2.0+ removed the `handlers` functionality. You must configure servers with `lspconfig` BEFORE calling `mason-lspconfig.setup()`.

**Correct Setup Order**:
```lua
-- 1. Define on_attach
local function on_attach(client, bufnr)
    -- keymaps and autocmds
end

-- 2. Get completion capabilities
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- 3. Configure servers with lspconfig FIRST
require('lspconfig').lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = { ... }
})

-- 4. THEN setup mason-lspconfig
require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', ... }
})
```

### 3. Installed Language Servers

**Automatically installed via mason-lspconfig**:

#### Web Development
- `ts_ls` - TypeScript/JavaScript
- `html` - HTML
- `cssls` - CSS
- `tailwindcss` - Tailwind CSS
- `eslint` - ESLint
- `emmet_ls` - Emmet

#### Python
- `pyright` - Python type checking and IntelliSense

#### DevOps & Infrastructure
- `dockerls` - Docker
- `docker_compose_language_service` - Docker Compose
- `yamlls` - YAML
- `ansiblels` - Ansible
- `bashls` - Bash/Shell
- `nginx_language_server` - Nginx
- `terraformls` - Terraform

#### Database
- `sqlls` - SQL

#### Configuration
- `jsonls` - JSON
- `taplo` - TOML

#### Documentation
- `marksman` - Markdown

#### Systems Programming
- `rust_analyzer` - Rust
- `clangd` - C/C++

#### Scripting
- `lua_ls` - Lua (enhanced for Neovim development)
- `powershell_es` - PowerShell

## Language Server Setup

### lua_ls (Enhanced Configuration)

**Special configuration for Neovim development**:

```lua
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = runtime_path,
            },
            diagnostics = {
                globals = { 'vim' },
                disable = { 'missing-fields', 'incomplete-signature-doc' },
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME .. '/lua',
                    vim.env.VIMRUNTIME .. '/lua/vim',
                    vim.env.VIMRUNTIME .. '/lua/vim/lsp',
                    vim.fn.stdpath('config') .. '/lua',
                },
                checkThirdParty = false,
                maxPreload = 100000,
                preloadFileSize = 50000,
            },
            completion = {
                enable = true,
                callSnippet = "Replace",
                keywordSnippet = "Replace",
            },
            hint = {
                enable = true,
                setType = true,
                paramType = true,
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "4",
                    quote_style = "single",
                }
            },
        },
    },
})
```

**Key Settings Explained**:

- **runtime.version**: `LuaJIT` - Matches Neovim's Lua runtime
- **workspace.library**: Includes Neovim runtime paths for `vim.api.*` completions
- **diagnostics.disable**: Removes overly strict warnings for config files
- **completion.callSnippet**: `"Replace"` - Provides function signatures as snippets
- **hint.enable**: Enables inlay hints for type annotations
- **format**: 4-space indentation with single quotes

## Completion Engine

### blink.cmp Configuration

**File**: `lua/evanusmodestus/modules/plugins/blink-cmp.lua`

**Performance**: 2-10x faster than nvim-cmp due to Rust-powered SIMD fuzzy matching

**Source Priority**:
```lua
sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
        lsp = {
            score_offset = 100,  -- Highest priority
        },
        snippets = {
            score_offset = 80,
        },
        path = {
            score_offset = 50,
        },
        buffer = {
            score_offset = -50,  -- Lowest priority
            min_keyword_length = 4,
        },
    },
},
```

**Snippet Integration**:
```lua
snippets = {
    preset = 'luasnip',  -- Uses LuaSnip for snippet expansion
},
```

**Completion Behavior**:
- **Auto-show**: Appears automatically after typing
- **Auto-insert**: Completes on selection
- **Ghost Text**: Shows preview of completion inline
- **Signature Help**: Displays function signatures while typing

**Keymap Integration**:
- `<Tab>` / `<CR>` - Accept completion
- `<C-n>` / `<C-p>` - Navigate items
- `<C-Space>` - Toggle completion menu
- `<C-e>` - Hide completions
- `<C-b>` / `<C-f>` - Scroll documentation

## Keymaps Reference

### Navigation

| Keymap | Action | Description |
|--------|--------|-------------|
| `gd` | Go to Definition | Jump to where symbol is defined |
| `gD` | Go to Declaration | Jump to symbol declaration |
| `gi` | Go to Implementation | Jump to implementation |
| `go` | Go to Type Definition | Jump to type definition |
| `<leader>vrr` | Find References | List all references to symbol |

### Information

| Keymap | Action | Description |
|--------|--------|-------------|
| `K` | Hover Documentation | Show documentation in floating window |
| `<C-h>` (Insert) | Signature Help | Show function signature while typing |

### Diagnostics

| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>vd` | Show Diagnostic Float | Display error/warning details |
| `[d` | Previous Diagnostic | Jump to previous error/warning |
| `]d` | Next Diagnostic | Jump to next error/warning |
| `<leader>vq` | Diagnostics to Quickfix | Send all diagnostics to quickfix list |

### Code Actions

| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>vca` | Code Action | Show available code actions |
| `<leader>vrn` | Rename Symbol | Rename symbol across workspace |
| `<leader>vws` | Workspace Symbol Search | Search symbols in entire workspace |
| `<leader>vf` | Format Buffer | Format current buffer |
| `<leader>vh` | Toggle Inlay Hints | Show/hide type annotations |

## Advanced Features

### 1. Inlay Hints

**What are Inlay Hints?**
Type annotations displayed inline in your code without modifying the actual file.

**Example**:
```lua
-- Without inlay hints:
local function add(a, b)
    return a + b
end

-- With inlay hints enabled:
local function add(a: number, b: number): number
    return a + b
end
```

**Toggle**: `<leader>vh`

**Configuration**:
```lua
hint = {
    enable = true,
    setType = true,      -- Show variable type hints
    paramType = true,    -- Show parameter type hints
    paramName = "Disable",  -- Don't show parameter names
}
```

### 2. Auto-Format on Save

**Applies to**: Lua files only (to prevent unwanted formatting)

**Behavior**: Automatically formats Lua files when saving

**Configuration**:
```lua
if vim.bo[bufnr].filetype == 'lua' then
    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
    })
end
```

**Manual Format**: `<leader>vf` (any file with formatting support)

### 3. Enhanced Diagnostics

**Disabled Warnings**:
- `missing-fields` - Prevents warnings for optional table fields
- `incomplete-signature-doc` - Reduces noise for undocumented parameters

**Quickfix Integration**:
Send all diagnostics to quickfix list with `<leader>vq` for easy navigation:
```vim
:copen     " Open quickfix list
:cnext     " Next diagnostic
:cprev     " Previous diagnostic
```

### 4. Workspace Configuration

**Optimized for Large Projects**:
```lua
workspace = {
    maxPreload = 100000,      -- Index up to 100k files
    preloadFileSize = 50000,  -- Files up to 50kb
    checkThirdParty = false,  -- Skip third-party library prompts
}
```

## Troubleshooting

### Debug Commands

#### :CheckLuaCompletion

**Custom command for debugging LSP completions**:

```vim
:CheckLuaCompletion
```

**What it checks**:
1. Is lua_ls attached to current buffer?
2. Does lua_ls have workspace.library configured?
3. Can LSP provide completions for `vim.api.nvim_`?

**Location**: `lua/evanusmodestus/modules/lsp/debug.lua`

#### :LspInfo

**Built-in Neovim command**:
```vim
:LspInfo
```

**Shows**:
- Active language servers for current buffer
- Server capabilities
- Server configuration

#### :LspLog

**View LSP communication logs**:
```vim
:LspLog
```

**Useful for**: Debugging server communication issues

#### :Mason

**Open Mason UI**:
```vim
:Mason
```

**Actions**:
- `i` - Install server
- `u` - Update server
- `U` - Update all servers
- `X` - Uninstall server

### Common Issues

#### Issue: LSP completions not appearing

**Symptoms**: Only buffer/snippet completions show, no LSP suggestions

**Diagnosis**:
1. Run `:LspInfo` - Check if server is attached
2. Run `:CheckLuaCompletion` - Verify configuration
3. Check if Settings are populated (should not be `{}`)

**Solution**: Ensure lspconfig setup runs BEFORE mason-lspconfig.setup()

#### Issue: Inlay hints not working

**Symptoms**: `<leader>vh` doesn't show type annotations

**Diagnosis**:
```lua
:lua print(vim.lsp.inlay_hint and "Available" or "Not available")
```

**Requirements**:
- Neovim 0.10+
- Language server with inlayHintProvider capability

#### Issue: Auto-format not triggering

**Symptoms**: Lua files don't format on save

**Diagnosis**:
```vim
:autocmd BufWritePre *.lua
```

**Should show**: Autocmd for LSP formatting

**Solution**: Ensure `documentFormattingProvider` capability is true:
```vim
:lua print(vim.lsp.get_active_clients()[1].server_capabilities.documentFormattingProvider)
```

#### Issue: Snippets not expanding

**Symptoms**: Typing snippet triggers shows nothing

**Diagnosis**:
1. Check blink.cmp sources: `:lua print(vim.inspect(require('blink.cmp').config.sources.default))`
2. Should include `'snippets'`

**Solution**: Ensure `preset = 'luasnip'` is set in blink-cmp.lua

### Performance Optimization

#### Limit Workspace Scanning

For very large projects, reduce workspace scanning:
```lua
workspace = {
    maxPreload = 10000,      -- Reduce from 100k
    preloadFileSize = 10000, -- Reduce from 50kb
}
```

#### Disable Unused Language Servers

Comment out servers you don't need in mason-lspconfig:
```lua
ensure_installed = {
    'lua_ls',  -- Keep only what you use
    -- 'rust_analyzer',  -- Comment out unused servers
}
```

#### Check Startup Time

```vim
:Lazy profile
```

Shows plugin loading times. LSP should load in <50ms.

## File Reference

### Core Configuration Files

| File | Purpose |
|------|---------|
| `lua/evanusmodestus/modules/lsp/init.lua` | Main LSP configuration |
| `lua/evanusmodestus/modules/lsp/debug.lua` | Debug utilities and commands |
| `lua/evanusmodestus/modules/plugins/blink-cmp.lua` | Completion engine setup |
| `lua/evanusmodestus/lazy-plugins.lua` | Plugin specifications |

### Related Documentation

- [KEYMAP_REFERENCE.md](KEYMAP_REFERENCE.md) - Complete keymap listing
- [README.md](README.md) - General setup and features
- [CONFIGURATION_SUMMARY.md](CONFIGURATION_SUMMARY.md) - Quick reference

---

**💡 Pro Tips**:

1. Use `:Telescope lsp_document_symbols` to search symbols in current file
2. Use `:Telescope lsp_workspace_symbols` to search across entire project
3. Combine diagnostics with quickfix: `<leader>vq` then `:copen`
4. Use `:checkhealth vim.lsp` to verify LSP health
5. Enable inlay hints temporarily with `<leader>vh` when exploring unfamiliar code

*🚀 Built for performance • 🔧 Optimized for Neovim development • 📚 Comprehensive language support*
