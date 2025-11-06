-- Lazy.nvim plugin specifications
-- All plugin definitions with lazy loading configurations

local plugins = {
    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        lazy = false,
        priority = 900,
        config = function()
            local telescope = require('evanusmodestus.modules.plugins.telescope')
            telescope.setup()
            -- Defer keymaps to ensure everything is loaded
            vim.defer_fn(function()
                telescope.keymaps()
            end, 50)
        end,
    },

    -- Telescope Extensions
    {
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    },
    {
        'nvim-telescope/telescope-project.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim' },
    },
    {
        'debugloop/telescope-undo.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim' },
    },

    -- Colorscheme
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        priority = 1000,
        config = function()
            require('evanusmodestus.modules.ui.colorscheme').setup()
        end
    },

    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 999,
        lazy = true, -- Don't load by default, available when you want to test
    },

    {
        'folke/tokyonight.nvim',
        priority = 999,
        lazy = true,
    },
    {
        'rebelot/kanagawa.nvim',
        priority = 999,
        lazy = true,
    },
    {
        'sainnhe/gruvbox-material',
        priority = 999,
        lazy = true,
    },
    {
        'shaunsingh/nord.nvim',
        priority = 999,
        lazy = true,
    },
    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('evanusmodestus.modules.plugins.treesitter').setup()
        end,
    },
    {
        'nvim-treesitter/playground',
        cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },  -- Load on command
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = 'BufReadPost',  -- Load after buffer read
    },

    -- Primeagen essentials
    {
        'theprimeagen/harpoon',
        keys = { '<leader>a', '<C-e>', '<C-h>', '<C-t>', '<C-n>', '<C-s>' },  -- Load on first keypress
        config = function()
            local harpoon = require('evanusmodestus.modules.plugins.harpoon')
            harpoon.setup()   -- Configure UI with wider window
            harpoon.keymaps() -- Set up keybindings
        end
    },
    {
        'theprimeagen/refactoring.nvim',
        keys = { { '<leader>re', mode = { 'n', 'x' } } },  -- Load on refactoring keypress
        config = function()
            local refactoring = require('evanusmodestus.modules.plugins.refactoring')
            refactoring.setup()
            refactoring.keymaps()
        end
    },
    {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',  -- Load on :UndotreeToggle command
        keys = '<leader>u',       -- Or on keypress
        config = function()
            require('evanusmodestus.modules.plugins.undotree').keymaps()
        end
    },
    {
        'tpope/vim-fugitive',
        cmd = { 'Git', 'G', 'Gdiffsplit', 'Gvdiffsplit', 'Gwrite', 'Gread' },  -- Load on git commands
        keys = { '<leader>gs', '<leader>gp' },  -- Or on git keybindings
        config = function()
            require('evanusmodestus.modules.plugins.fugitive').keymaps()
        end
    },

    -- UI and aesthetics
    {
        'nvim-tree/nvim-web-devicons',
        lazy = true,  -- Loaded as dependency by other plugins
    },
    {
        'folke/zen-mode.nvim',
        cmd = 'ZenMode',  -- Only load on :ZenMode command
    },
    {
        'github/copilot.vim',
        event = 'InsertEnter',  -- Only load when entering insert mode
    },
    {
        'laytan/cloak.nvim',
        ft = { 'sh', 'bash', 'zsh', 'fish', 'env', 'dotenv', 'yaml', 'json', 'toml', 'conf', 'config' },
        config = function()
            require('evanusmodestus.modules.plugins.cloak').setup()
        end
    },

    -- Visual improvements
    {
        'machakann/vim-highlightedyank',
        event = 'TextYankPost',
        config = function()
            vim.g.highlightedyank_highlight_duration = 200
        end,
    },
    {
        'RRethy/vim-illuminate',
        event = 'BufReadPost',
        config = function()
            require('illuminate').configure({
                delay = 200,
                large_file_cutoff = 2000,
            })
        end,
    },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = 'BufReadPost',
        config = function()
            require('evanusmodestus.modules.plugins.nvim-ufo').setup()
        end
    },
    -- Productivity plugins
    {
        'numToStr/Comment.nvim',
        config = function()
            require('evanusmodestus.modules.plugins.comment').setup()
        end
    },
    {
        'windwp/nvim-autopairs',
        config = function()
            require('evanusmodestus.modules.plugins.autopairs').setup()
        end
    },
    {
        'windwp/nvim-ts-autotag',
        ft = { 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'xml', 'markdown' },
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('evanusmodestus.modules.plugins.gitsigns').setup()
        end
    },
    {
        'stevearc/oil.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('evanusmodestus.modules.plugins.oil').setup()
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('evanusmodestus.modules.ui.lualine').setup()
        end
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'BufReadPost',
    },
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('evanusmodestus.modules.plugins.colorizer').setup()
        end
    },

    -- Database
    {
        'tpope/vim-dadbod',
        cmd = 'DB',
    },
    {
        'kristijanhusak/vim-dadbod-ui',
        cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
        dependencies = { 'tpope/vim-dadbod' },
    },
    {
        'kristijanhusak/vim-dadbod-completion',
        ft = { 'sql', 'mysql', 'plsql' },
        dependencies = { 'tpope/vim-dadbod' },
    },

    -- Debugging
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'theHamsta/nvim-dap-virtual-text',
            -- build = false resolves luarocks conflicts; see https://github.com/mfussenegger/nvim-dap-python/issues/43
            { 'mfussenegger/nvim-dap-python', build = false },
            'nvim-neotest/nvim-nio',
        },
        config = function()
            local dap = require('evanusmodestus.modules.plugins.dap')
            dap.setup()
            dap.keymaps()
        end
    },

    -- Additional UI improvements
    {
        'j-hui/fidget.nvim',
        config = function()
            require('evanusmodestus.modules.plugins.fidget').setup()
        end
    },

    -- Markdown Preview
    {
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = 'cd app && npm install',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
            -- Auto-detect environment and use appropriate browser command
            local handle = io.popen('uname -r')
            local kernel = handle:read('*a')
            handle:close()

            if kernel:match('[Mm]icrosoft') then
                -- WSL detected
                vim.g.mkdp_browser = 'wsl-open'
            else
                -- Native Linux (Arch VM, etc.)
                vim.g.mkdp_browser = 'firefox'
            end
        end,
    },

    -- Glow markdown viewer
    {
        'ellisonleao/glow.nvim',
        config = true,
        cmd = 'Glow'
    },

    -- Obsidian & Note-taking plugins
    {
        'epwalsh/obsidian.nvim',
        version = '*',
        lazy = true,
        ft = 'markdown',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        opts = {
            workspaces = {
                {
                    name = 'Aethelred-Codex',
                    path = '~/Aethelred-Codex',
                },
            },
            completion = {
                nvim_cmp = false, -- Disabled: using blink.cmp instead
                min_chars = 2,
            },
            mappings = {
                ['gf'] = {
                    action = function()
                        return require('obsidian').util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
            },
            -- Disable auto-frontmatter (use manual 'frontmatter' snippet instead)
            disable_frontmatter = true,
            -- UI settings - set conceallevel for prettier markdown
            ui = {
                enable = true,
                checkboxes = {
                    [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
                    ['x'] = { char = '', hl_group = 'ObsidianDone' },
                },
            },
        },
    },

    -- Obsidian Capture System (load globally, always available)
    {
        'nvim-lua/plenary.nvim', -- Already a dependency of Telescope
        config = function()
            local capture = require('evanusmodestus.modules.plugins.obsidian-capture')
            capture.setup()
            capture.keymaps()
        end,
    },

    -- Better markdown support
    {
        'preservim/vim-markdown',
        ft = 'markdown',
        config = function()
            vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_conceal = 0
            vim.g.vim_markdown_frontmatter = 1

            -- Load custom markdown snippets and commands
            local markdown = require('evanusmodestus.modules.plugins.markdown')
            markdown.setup()
            markdown.autocmds()
            markdown.commands()

            -- Load Obsidian vault template snippets
            local templates = require('evanusmodestus.modules.plugins.obsidian-templates')
            templates.setup()
        end,
    },

    -- Auto bullet lists
    {
        'bullets-vim/bullets.vim',
        ft = { 'markdown', 'text' },
    },

    -- Enhanced table editing
    {
        'dhruvasagar/vim-table-mode',
        ft = 'markdown',
        config = function()
            -- Use standard markdown table format
            vim.g.table_mode_corner = '|'
            vim.g.table_mode_header_fillchar = '-'
            vim.g.table_mode_align_char = ':'

            -- Disable default table mode keybindings that might conflict
            vim.g.table_mode_map_prefix = '<Leader>t'
            vim.g.table_mode_toggle_map = 'm' -- <Leader>tm to toggle

            -- Auto-format tables on the fly
            vim.g.table_mode_auto_align = 1
        end,
    },

    -- Better terminal
    {
        'akinsho/toggleterm.nvim',
        config = function()
            local toggleterm = require('evanusmodestus.modules.plugins.toggleterm')
            toggleterm.setup()
            toggleterm.keymaps()
        end
    },

    -- Session management
    {
        'rmagatti/auto-session',
        config = function()
            require('evanusmodestus.modules.plugins.auto-session').setup()
        end
    },

    -- Which-key for keybinding help
    {
        'folke/which-key.nvim',
        config = function()
            require('evanusmodestus.modules.plugins.which-key').setup()
        end
    },

    -- Network/Cisco configuration support
    'momota/cisco.vim',
    'momota/junos.vim',

    -- HTTP Client is handled by our custom simple-rest.lua module
    -- No external plugin needed - using curl for API requests

    -- CSV plugins
    {
        'hat0uma/csvview.nvim',
        ft = { 'csv', 'tsv' },
        opts = {},
    },
    {
        'cameron-wags/rainbow_csv.nvim',
        ft = { 'csv', 'tsv', 'csv_semicolon', 'csv_whitespace', 'csv_pipe', 'rfc_csv', 'rfc_semicolon' },
        cmd = {
            'RainbowDelim',
            'RainbowDelimSimple',
            'RainbowDelimQuoted',
            'RainbowMultiDelim'
        },
        config = true,
    },

    -- blink.cmp - Fast completion engine
    {
        'saghen/blink.cmp',
        lazy = false,
        version = 'v0.*',
        build = 'cargo build --release', -- Optional: Uncomment if you have Rust/cargo installed for 6x faster fuzzy matching
        dependencies = {
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
        },
        config = function()
            require('evanusmodestus.modules.plugins.blink-cmp').setup()
        end
    },

    -- LSP Zero and dependencies (nvim-cmp replaced by blink.cmp)
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            -- nvim-cmp dependencies removed (using blink.cmp instead)
            -- Keep LuaSnip for snippets
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
        },
        config = function()
            require('evanusmodestus.modules.lsp').setup()
        end
    },

    -- Glance - LSP peek with multiple results
    {
        'dnlhc/glance.nvim',
        config = function()
            require('glance').setup({
                border = { enable = true },
            })

            vim.keymap.set('n', 'gD', '<CMD>Glance definitions<CR>', { desc = 'Glance definitions' })
            vim.keymap.set('n', 'gR', '<CMD>Glance references<CR>', { desc = 'Glance references' })
            vim.keymap.set('n', 'gY', '<CMD>Glance type_definitions<CR>', { desc = 'Glance type definitions' })
            vim.keymap.set('n', 'gM', '<CMD>Glance implementations<CR>', { desc = 'Glance implementations' })
        end
    },
}

return plugins
