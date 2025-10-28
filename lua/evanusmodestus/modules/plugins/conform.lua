-- ============================================================================
-- FILE: conform.nvim
-- PURPOSE: Lightweight formatting plugin - replaces null-ls/none-ls
-- REPOSITORY: https://github.com/stevearc/conform.nvim
-- ============================================================================
--
-- WHAT THIS DOES:
-- - Async formatting (doesn't block editor)
-- - Multiple formatters per filetype
-- - Falls back gracefully if formatter not installed
-- - Format on save (configurable)
-- - Much faster than null-ls
--
-- INSTALLATION:
-- Formatters must be installed separately:
--   Python:  pip install black isort
--   JavaScript/TypeScript: npm install -g prettier
--   Lua: Install stylua (cargo install stylua or download binary)
--   Go: Install gofmt/goimports (comes with Go)
--   Rust: Install rustfmt (rustup component add rustfmt)
--   Shell: Install shfmt (brew install shfmt or download)
--   YAML/JSON/Markdown: Prettier handles these too
--
-- ============================================================================

return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    opts = {
        -- Define formatters by filetype
        formatters_by_ft = {
            -- Python
            python = { "isort", "black" },  -- Sort imports, then format with black

            -- JavaScript/TypeScript
            javascript = { { "prettierd", "prettier" } },  -- Try prettierd first, fall back to prettier
            typescript = { { "prettierd", "prettier" } },
            javascriptreact = { { "prettierd", "prettier" } },
            typescriptreact = { { "prettierd", "prettier" } },

            -- Lua
            lua = { "stylua" },

            -- Go
            go = { "goimports", "gofmt" },  -- Organize imports, then format

            -- Rust
            rust = { "rustfmt" },

            -- C/C++
            c = { "clang_format" },
            cpp = { "clang_format" },

            -- Shell
            sh = { "shfmt" },
            bash = { "shfmt" },

            -- Web
            html = { { "prettierd", "prettier" } },
            css = { { "prettierd", "prettier" } },
            scss = { { "prettierd", "prettier" } },

            -- Data formats
            json = { { "prettierd", "prettier" } },
            jsonc = { { "prettierd", "prettier" } },
            yaml = { { "prettierd", "prettier" } },
            toml = { "taplo" },

            -- Markdown
            markdown = { { "prettierd", "prettier" } },

            -- SQL
            sql = { "sql_formatter" },

            -- Use "*" to run formatters on all filetypes
            ["*"] = { "codespell" },  -- Spell check all files

            -- Use "_" to run formatters on filetypes that don't have other formatters
            ["_"] = { "trim_whitespace" },  -- Trim whitespace for unmatched filetypes
        },

        -- ====================================================================
        -- FORMAT ON SAVE
        -- ====================================================================
        format_on_save = function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end

            return {
                -- These options will be passed to conform.format()
                timeout_ms = 500,
                lsp_fallback = true,  -- Use LSP formatter if conform formatter not available
            }
        end,

        -- ====================================================================
        -- FORMAT AFTER SAVE (for slow formatters)
        -- ====================================================================
        format_after_save = function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end

            -- Only format these filetypes after save (they're slow)
            local slow_format_filetypes = { "rust", "go" }
            if vim.tbl_contains(slow_format_filetypes, vim.bo[bufnr].filetype) then
                return { lsp_fallback = true }
            end
        end,

        -- ====================================================================
        -- FORMATTER CONFIGURATIONS
        -- ====================================================================
        formatters = {
            -- Python
            black = {
                prepend_args = { "--fast", "--line-length", "88" },
            },
            isort = {
                prepend_args = { "--profile", "black" },  -- Compatible with black
            },

            -- JavaScript/TypeScript
            prettier = {
                prepend_args = {
                    "--single-quote",
                    "--trailing-comma", "es5",
                    "--print-width", "100",
                    "--tab-width", "2",
                },
            },
            prettierd = {
                prepend_args = {
                    "--single-quote",
                    "--trailing-comma", "es5",
                    "--print-width", "100",
                    "--tab-width", "2",
                },
            },

            -- Lua
            stylua = {
                prepend_args = {
                    "--indent-type", "Spaces",
                    "--indent-width", "4",
                    "--column-width", "100",
                },
            },

            -- Shell
            shfmt = {
                prepend_args = { "-i", "2", "-ci" },  -- 2 spaces, case indent
            },

            -- C/C++
            clang_format = {
                prepend_args = {
                    "--style",
                    "{BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 100}",
                },
            },
        },
    },

    -- ========================================================================
    -- ADDITIONAL CONFIGURATION
    -- ========================================================================
    config = function(_, opts)
        require("conform").setup(opts)

        -- ====================================================================
        -- USER COMMANDS
        -- ====================================================================

        -- Toggle format on save
        vim.api.nvim_create_user_command("FormatToggle", function(args)
            if args.bang then
                -- Toggle buffer-local setting
                vim.b.disable_autoformat = not vim.b.disable_autoformat
                vim.notify(
                    "Format on save " .. (vim.b.disable_autoformat and "disabled" or "enabled") .. " for this buffer",
                    vim.log.levels.INFO
                )
            else
                -- Toggle global setting
                vim.g.disable_autoformat = not vim.g.disable_autoformat
                vim.notify(
                    "Format on save " .. (vim.g.disable_autoformat and "disabled" or "enabled") .. " globally",
                    vim.log.levels.INFO
                )
            end
        end, {
            desc = "Toggle autoformat-on-save (use ! for buffer-local)",
            bang = true,
        })

        -- Format command
        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            require("conform").format({ async = true, lsp_fallback = true, range = range })
        end, { range = true, desc = "Format buffer or range" })

        -- ====================================================================
        -- STATUSLINE INTEGRATION
        -- ====================================================================
        -- Get active formatters for statusline
        _G.get_formatters = function()
            local conform = require("conform")
            local formatters = conform.list_formatters(0)
            if #formatters == 0 then
                return "LSP"
            end
            local names = vim.tbl_map(function(f)
                return f.name
            end, formatters)
            return table.concat(names, ", ")
        end
    end,
}

-- ============================================================================
-- USAGE GUIDE
-- ============================================================================
--
-- KEYBINDINGS:
--   <leader>f     - Format current buffer/selection
--
-- COMMANDS:
--   :Format       - Format buffer
--   :Format!      - Format selection/range
--   :FormatToggle - Toggle format-on-save globally
--   :FormatToggle! - Toggle format-on-save for current buffer only
--   :ConformInfo  - Show formatter info for current buffer
--
-- FORMAT ON SAVE:
--   - Enabled by default
--   - Disable globally: :FormatToggle
--   - Disable for current buffer: :FormatToggle!
--   - Or set vim.g.disable_autoformat = true in config
--
-- INSTALL FORMATTERS:
--   Python:
--     pip install black isort
--
--   JavaScript/TypeScript:
--     npm install -g prettier
--     npm install -g @fsouza/prettierd  # Faster alternative
--
--   Lua:
--     cargo install stylua
--     # Or download: https://github.com/JohnnyMorganz/StyLua/releases
--
--   Go:
--     # Comes with Go installation
--     go install golang.org/x/tools/cmd/goimports@latest
--
--   Rust:
--     rustup component add rustfmt
--
--   Shell:
--     brew install shfmt  # macOS
--     # Or download: https://github.com/mvdan/sh/releases
--
--   C/C++:
--     sudo apt install clang-format  # Linux
--     brew install clang-format      # macOS
--
--   SQL:
--     npm install -g sql-formatter
--
--   TOML:
--     cargo install taplo-cli
--
-- STATUSLINE INTEGRATION:
--   Add to your statusline:
--     %{v:lua.get_formatters()}
--
-- ============================================================================
