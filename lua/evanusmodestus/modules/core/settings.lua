-- Core Neovim settings migrated from set.lua
-- All core Neovim options and configurations

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Text wrapping
vim.opt.wrap = false

-- File management
vim.opt.swapfile = true                                 -- Enable swap files for crash recovery
vim.opt.backup = true                                   -- Enable backup files
vim.opt.backupdir = vim.fn.stdpath('data') .. '/backup' -- Cross-platform path
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'  -- Already correct
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 50

-- Search settings
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Visual settings
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '80'
vim.opt.isfname:append('@-@')

-- Update time for faster completions
vim.opt.updatetime = 50

-- Netrw (file browser) settings
vim.g.netrw_bufsettings = 'noma nomod rnu nobl nowrap ro'

-- Clipboard Configuration (auto-detect environment)
-- Only set win32yank if it's available (WSL), otherwise let neovim auto-detect
if vim.fn.executable('win32yank.exe') == 1 then
    vim.g.clipboard = {
        name = 'win32yank-wsl',
        copy = {
            ['+'] = 'win32yank.exe -i --crlf',
            ['*'] = 'win32yank.exe -i --crlf',
        },
        paste = {
            ['+'] = 'win32yank.exe -o --lf',
            ['*'] = 'win32yank.exe -o --lf',
        },
        cache_enabled = 0,
    }
end
-- If win32yank doesn't exist, vim.g.clipboard remains unset and neovim will
-- auto-detect xclip, xsel, or other clipboard providers on native Linux

-- Use system clipboard
vim.opt.clipboard = 'unnamedplus'

-- Set leader key early
vim.g.mapleader = ' '
