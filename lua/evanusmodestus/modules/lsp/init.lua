-- LSP configuration with LSP Zero
-- Updated for Neovim 0.11+ to avoid deprecation warnings

local M = {}

function M.setup()
    local lsp_zero_ok, lsp_zero = pcall(require, 'lsp-zero')
    if not lsp_zero_ok then
        return
    end

    -- Define on_attach function for LSP keymaps
    local function on_attach(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        -- Navigation
        vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set('n', 'go', function() vim.lsp.buf.type_definition() end, opts)
        vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)

        -- Information
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)

        -- Diagnostics
        vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', '<leader>vq', function() vim.diagnostic.setloclist() end, opts)

        -- Actions
        vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)

        -- Formatting (if supported)
        if client.server_capabilities.documentFormattingProvider then
            vim.keymap.set('n', '<leader>vf', function() vim.lsp.buf.format({ async = true }) end, opts)

            -- Auto-format on save for Lua files
            if vim.bo[bufnr].filetype == 'lua' then
                vim.api.nvim_create_autocmd('BufWritePre', {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })
            end
        end

        -- Inlay hints (if supported)
        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.keymap.set('n', '<leader>vh', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, opts)
        end
    end

    -- Register with lsp-zero
    lsp_zero.on_attach(on_attach)

    -- Get blink.cmp capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local blink_ok, blink = pcall(require, 'blink.cmp')
    if blink_ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
    end

    -- Check if we should use the new vim.lsp.config API or fall back to lspconfig
    local use_new_api = vim.lsp.config ~= nil

    if use_new_api then
        -- Use the new Neovim 0.11+ API
        local vimruntime = vim.env.VIMRUNTIME or vim.fn.expand('$VIMRUNTIME')
        local runtime_path = vim.split(package.path, ';')
        table.insert(runtime_path, 'lua/?.lua')
        table.insert(runtime_path, 'lua/?/init.lua')

        -- lua_ls configuration using new API
        vim.lsp.config.lua_ls = {
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
                            vimruntime .. '/lua',
                            vimruntime .. '/lua/vim',
                            vimruntime .. '/lua/vim/lsp',
                            vim.fn.stdpath('config') .. '/lua',
                        },
                        checkThirdParty = false,
                        maxPreload = 100000,
                        preloadFileSize = 50000,
                        ignoreDir = {
                            -- Development tools
                            'node_modules',
                            '.git',
                            '.github',
                            '.vscode',
                            '.idea',
                            'venv',
                            '.venv',
                            'env',
                            '.env',
                            '__pycache__',
                            'target',
                            'build',
                            'dist',
                            '.next',

                            -- Windows-specific
                            'AppData',
                            'Application Data',

                            -- Linux-specific
                            '.cache',
                            '.local',
                            '.config',
                            '.cargo',
                            '.rustup',
                            '.npm',
                            '.gradle',

                            -- Common user folders
                            'Downloads',
                            'Documents',
                            'Pictures',
                            'Videos',
                            'Music',
                            'Desktop',

                            -- Temporary/cache
                            'tmp',
                            'temp',
                            '.tmp',
                            '.Trash',
                        },
                    },
                    telemetry = {
                        enable = false,
                    },
                    completion = {
                        enable = true,
                        callSnippet = 'Replace',
                        keywordSnippet = 'Replace',
                    },
                    hint = {
                        enable = true,
                        setType = true,
                        paramType = true,
                        paramName = 'Disable',
                        semicolon = 'Disable',
                        arrayIndex = 'Disable',
                    },
                    format = {
                        enable = true,
                        defaultConfig = {
                            indent_style = 'space',
                            indent_size = '4',
                            quote_style = 'single',
                        }
                    },
                },
            },
        }

        -- Enable lua_ls using the new API
        vim.lsp.enable('lua_ls')
    else
        -- Fall back to traditional lspconfig for older Neovim versions
        local lspconfig = require('lspconfig')
        local vimruntime = vim.env.VIMRUNTIME or vim.fn.expand('$VIMRUNTIME')
        local runtime_path = vim.split(package.path, ';')
        table.insert(runtime_path, 'lua/?.lua')
        table.insert(runtime_path, 'lua/?/init.lua')

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
                            vimruntime .. '/lua',
                            vimruntime .. '/lua/vim',
                            vimruntime .. '/lua/vim/lsp',
                            vim.fn.stdpath('config') .. '/lua',
                        },
                        checkThirdParty = false,
                        maxPreload = 100000,
                        preloadFileSize = 50000,
                        ignoreDir = {
                            -- Development tools
                            'node_modules',
                            '.git',
                            '.github',
                            '.vscode',
                            '.idea',
                            'venv',
                            '.venv',
                            'env',
                            '.env',
                            '__pycache__',
                            'target',
                            'build',
                            'dist',
                            '.next',

                            -- Windows-specific
                            'AppData',
                            'Application Data',

                            -- Linux-specific
                            '.cache',
                            '.local',
                            '.config',
                            '.cargo',
                            '.rustup',
                            '.npm',
                            '.gradle',

                            -- Common user folders
                            'Downloads',
                            'Documents',
                            'Pictures',
                            'Videos',
                            'Music',
                            'Desktop',

                            -- Temporary/cache
                            'tmp',
                            'temp',
                            '.tmp',
                            '.Trash',
                        },
                    },
                    telemetry = {
                        enable = false,
                    },
                    completion = {
                        enable = true,
                        callSnippet = 'Replace',
                        keywordSnippet = 'Replace',
                    },
                    hint = {
                        enable = true,
                        setType = true,
                        paramType = true,
                        paramName = 'Disable',
                        semicolon = 'Disable',
                        arrayIndex = 'Disable',
                    },
                    format = {
                        enable = true,
                        defaultConfig = {
                            indent_style = 'space',
                            indent_size = '4',
                            quote_style = 'single',
                        }
                    },
                },
            },
        })
    end

    -- Mason setup (remains the same)
    require('mason').setup({})

    -- Note: mason-lspconfig handlers might need updating
    -- Check if your version supports the new API
    require('mason-lspconfig').setup({
        ensure_installed = {
            -- Web Development
            'ts_ls',
            'html',
            'cssls',
            'tailwindcss',
            'eslint',
            'emmet_ls',

            -- Python
            'pyright',

            -- DevOps & Infrastructure
            'dockerls',
            'docker_compose_language_service',
            'yamlls',
            'ansiblels',
            'bashls',

            -- Database
            'sqlls',

            -- Configuration
            'jsonls',
            'taplo', -- TOML

            -- Documentation
            'marksman', -- Markdown

            -- Systems Programming
            'rust_analyzer',
            'clangd', -- C/C++

            -- Lua
            'lua_ls',

            -- PowerShell
            'powershell_es',

            -- Infrastructure & DevOps
            'nginx_language_server',
            'terraformls',
        },
        handlers = {
            -- Default handler for all servers except lua_ls
            function(server_name)
                if server_name ~= 'lua_ls' then
                    if use_new_api and vim.lsp.config[server_name] then
                        -- Use new API if available
                        vim.lsp.config[server_name] = {
                            on_attach = on_attach,
                            capabilities = capabilities,
                        }
                        vim.lsp.enable(server_name)
                    else
                        -- Fall back to lspconfig
                        require('lspconfig')[server_name].setup({
                            on_attach = on_attach,
                            capabilities = capabilities,
                        })
                    end
                end
            end,
        },
    })

    -- Load debug utilities
    require('evanusmodestus.modules.lsp.debug')
end

return M
