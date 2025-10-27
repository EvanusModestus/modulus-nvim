-- blink.cmp configuration

local M = {}

function M.setup()
    local ok, blink = pcall(require, 'blink.cmp')
    if not ok then
        vim.notify('blink.cmp not found', vim.log.levels.ERROR)
        return
    end

    -- Load LuaSnip snippets (friendly-snippets + custom)
    local luasnip_ok, luasnip = pcall(require, 'luasnip')
    if luasnip_ok then
        -- Load friendly-snippets from VSCode format
        require('luasnip.loaders.from_vscode').lazy_load()
        -- Note: Custom markdown snippets are loaded by markdown.lua setup()
    end

    blink.setup({
        -- ========================================================================
        -- Keymaps - Full control over completion behavior
        -- ========================================================================
        keymap = {
            preset = 'default',

            -- Show/hide completions
            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide', 'fallback' },

            -- Accept completion
            ['<C-y>'] = { 'accept', 'fallback' },
            ['<Tab>'] = { 'accept', 'fallback' },
            ['<CR>'] = { 'hide', 'fallback' },

            -- Navigate completions
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<Up>'] = { 'select_prev', 'fallback' },

            -- Documentation scrolling
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        },

        -- ========================================================================
        -- Appearance - Match your rose-pine theme
        -- ========================================================================
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono',

            -- Kind icons with Nerd Font icons
            kind_icons = {
                Text = '󰉿',
                Method = '󰆧',
                Function = '󰊕',
                Constructor = '', -- You can add an icon here if desired
                Field = '󰜢',
                Variable = '󰀫',
                Class = '󰠱',
                Interface = '',
                Module = '',
                Property = '󰜢',
                Unit = '󰑭',
                Value = '󰎠',
                Enum = '',
                Keyword = '󰌋',
                Snippet = '',
                Color = '󰏘',
                File = '󰈙',
                Reference = '󰈇',
                Folder = '󰉋',
                EnumMember = '',
                Constant = '󰏿',
                Struct = '󰙅',
                Event = '',
                Operator = '󰆕',
                TypeParameter = '',
            },
        },

        -- ========================================================================
        -- Sources Configuration - Priority and behavior
        -- ========================================================================
        sources = {
            -- Order matters! First source has highest priority
            default = { 'lsp', 'path', 'snippets', 'buffer' },

            -- Global source configuration
            min_keyword_length = 2, -- Start completing after 2 characters

            -- Per-source configuration
            providers = {
                lsp = {
                    name = 'lsp',
                    enabled = true,
                    module = 'blink.cmp.sources.lsp',
                    score_offset = 100, -- Highest priority
                    -- LSP configuration is handled by the server
                },
                path = {
                    name = 'path',
                    enabled = true,
                    module = 'blink.cmp.sources.path',
                    score_offset = 50,
                    -- Path provider uses defaults
                },
                snippets = {
                    name = 'snippets',
                    enabled = true,
                    module = 'blink.cmp.sources.snippets',
                    score_offset = 80,
                    -- Snippets are loaded via LuaSnip
                },
                buffer = {
                    name = 'buffer',
                    enabled = true,
                    module = 'blink.cmp.sources.buffer',
                    score_offset = -50,     -- Lowest priority
                    min_keyword_length = 4, -- Need 4 chars for buffer completions
                    -- This reduces noise from buffer completions
                },
            },
        },

        -- ========================================================================
        -- Completion Menu Configuration
        -- ========================================================================
        completion = {
            -- Keyword configuration
            keyword = {
                range = 'prefix', -- Only complete based on prefix
            },

            -- When to trigger completion
            trigger = {
                show_on_keyword = true,
                show_on_trigger_character = true,
            },

            -- List configuration
            list = {
                max_items = 200,         -- Show up to 200 items
                selection = {
                    preselect = true,    -- Preselect first item
                    auto_insert = false, -- Don't auto-insert on selection
                },
            },

            -- Menu appearance
            menu = {
                enabled = true,
                border = 'rounded',
                max_height = 10,
                draw = {
                    -- What to show in completion menu
                    columns = {
                        { 'kind_icon' },
                        { 'label',    'label_description', gap = 1 },
                        { 'kind' },
                    },
                    -- Add source indicator
                    components = {
                        kind_icon = {
                            ellipsis = false,
                            text = function(ctx)
                                local kind = ctx.kind or 'Unknown'
                                local icon = ctx.kind_icon or ''
                                return icon .. ' '
                            end,
                            highlight = function(ctx)
                                return 'BlinkCmpKind' .. ctx.kind
                            end,
                        },
                    },
                },
            },

            -- Documentation window
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                update_delay_ms = 50,
                window = {
                    max_width = 80,
                    max_height = 20,
                    border = 'rounded',
                    winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder',
                },
            },

            -- Ghost text (inline preview)
            ghost_text = {
                enabled = true,
            },
        },

        -- ========================================================================
        -- Fuzzy Matching Configuration
        -- ========================================================================
        fuzzy = {
            use_frecency = true,  -- Remember frequently used items
            use_proximity = true, -- Prefer items near cursor
        },

        -- ========================================================================
        -- Snippets Configuration (LuaSnip)
        -- ========================================================================
        snippets = {
            preset = 'luasnip',
            expand = function(snippet)
                require('luasnip').lsp_expand(snippet)
            end,
            active = function(filter)
                if filter and filter.direction then
                    return require('luasnip').jumpable(filter.direction)
                end
                return require('luasnip').in_snippet()
            end,
            jump = function(direction)
                require('luasnip').jump(direction)
            end,
        },

        -- ========================================================================
        -- Signature Help
        -- ========================================================================
        signature = {
            enabled = true,
            trigger = {
                blocked_trigger_characters = {},
                blocked_retrigger_characters = {},
                -- Show signature help on these characters
                show_on_trigger_character = true,
                show_on_insert_on_trigger_character = true,
            },
            window = {
                min_width = 20,
                max_width = 80,
                max_height = 10,
                border = 'rounded',
                winhighlight = 'Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder',
            },
        },
    })

    -- ========================================================================
    -- Highlight Groups - Match rose-pine theme
    -- ========================================================================
    vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { link = 'Pmenu' })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { link = 'FloatBorder' })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { link = 'PmenuSel' })
    vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { link = 'NormalFloat' })
    vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { link = 'FloatBorder' })
    vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { link = 'NormalFloat' })
    vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { link = 'FloatBorder' })
    vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { link = 'Comment' })

    -- Kind-specific highlights
    local kinds = { 'Text', 'Method', 'Function', 'Constructor', 'Field',
        'Variable', 'Class', 'Interface', 'Module', 'Property',
        'Unit', 'Value', 'Enum', 'Keyword', 'Snippet', 'Color',
        'File', 'Reference', 'Folder', 'EnumMember', 'Constant',
        'Struct', 'Event', 'Operator', 'TypeParameter' }

    for _, kind in ipairs(kinds) do
        vim.api.nvim_set_hl(0, 'BlinkCmpKind' .. kind, { link = 'Cmp' .. kind })
    end
end

return M
