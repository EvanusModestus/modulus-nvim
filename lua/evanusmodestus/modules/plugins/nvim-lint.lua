-- ============================================================================
-- FILE: nvim-lint
-- PURPOSE: Async linting plugin - runs linters and shows diagnostics
-- REPOSITORY: https://github.com/mfussenegger/nvim-lint
-- ============================================================================
--
-- WHAT THIS DOES:
-- - Runs linters asynchronously (doesn't block editor)
-- - Shows linter errors/warnings as LSP diagnostics
-- - Multiple linters per filetype
-- - Auto-lint on save, text changed, insert leave
-- - Complements LSP (LSP = language server, this = dedicated linters)
--
-- WHY USE THIS + LSP?
-- - LSP provides language-specific diagnostics (syntax errors, type errors)
-- - Linters provide style/quality checks (eslint, pylint, shellcheck)
-- - Together = comprehensive code quality checking
--
-- INSTALLATION:
-- Linters must be installed separately:
--   Python: pip install pylint flake8 mypy
--   JavaScript: npm install -g eslint
--   TypeScript: npm install -g eslint
--   Shell: apt/brew install shellcheck
--   Lua: luarocks install luacheck
--   Markdown: npm install -g markdownlint-cli
--   YAML: pip install yamllint
--   JSON: npm install -g jsonlint
--
-- ============================================================================

return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        -- ====================================================================
        -- LINTERS BY FILETYPE
        -- ====================================================================
        lint.linters_by_ft = {
            -- Python
            python = {
                "pylint",    -- Comprehensive linting
                "flake8",    -- Style guide enforcement
                -- "mypy",   -- Type checking (can be slow, uncomment if needed)
            },

            -- JavaScript/TypeScript
            javascript = { "eslint" },
            typescript = { "eslint" },
            javascriptreact = { "eslint" },
            typescriptreact = { "eslint" },

            -- Lua
            lua = { "luacheck" },

            -- Shell
            sh = { "shellcheck" },
            bash = { "shellcheck" },

            -- Markdown
            markdown = { "markdownlint" },

            -- YAML
            yaml = { "yamllint" },

            -- JSON
            json = { "jsonlint" },

            -- Docker
            dockerfile = { "hadolint" },

            -- Go
            -- go = { "golangcilint" },  -- Uncomment if installed

            -- SQL
            -- sql = { "sqlfluff" },  -- Uncomment if needed

            -- Terraform
            -- terraform = { "tflint" },  -- Uncomment if needed

            -- HTML
            -- html = { "htmlhint" },  -- Uncomment if needed

            -- CSS
            -- css = { "stylelint" },  -- Uncomment if needed
        }

        -- ====================================================================
        -- LINTER CONFIGURATIONS
        -- ====================================================================

        -- Python: Pylint
        lint.linters.pylint.args = {
            "-f", "json",
            "--disable=C0111",  -- Disable missing docstring warnings
            "--max-line-length=88",  -- Match Black formatter
            "--good-names=i,j,k,ex,_,x,y,z,df,fp",  -- Allow common short names
        }

        -- Python: Flake8
        lint.linters.flake8.args = {
            "--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s",
            "--max-line-length=88",  -- Match Black formatter
            "--extend-ignore=E203,W503",  -- Ignore conflicts with Black
            "--no-show-source",
        }

        -- Lua: Luacheck
        lint.linters.luacheck.args = {
            "--formatter", "plain",
            "--codes",
            "--ranges",
            "--globals", "vim",  -- Allow vim global
            "--max-line-length", "100",
        }

        -- Shell: Shellcheck
        lint.linters.shellcheck.args = {
            "--format", "json",
            "--shell", "bash",
            "--severity", "style",  -- Show all severity levels
            "-",
        }

        -- Markdown: Markdownlint
        lint.linters.markdownlint.args = {
            "--json",
            "--config", vim.fn.stdpath("config") .. "/.markdownlint.json",  -- Use config if exists
            "--",
        }

        -- ====================================================================
        -- AUTO-LINT TRIGGERS
        -- ====================================================================
        local lint_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })

        -- Lint on these events
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                -- Only lint if linters are configured for this filetype
                local ft = vim.bo.filetype
                if lint.linters_by_ft[ft] then
                    lint.try_lint()
                end
            end,
            desc = "Trigger linting",
        })

        -- Also lint on text changed (debounced)
        vim.api.nvim_create_autocmd("TextChanged", {
            group = lint_augroup,
            callback = function()
                -- Debounce: only lint 500ms after stopping typing
                vim.defer_fn(function()
                    local ft = vim.bo.filetype
                    if lint.linters_by_ft[ft] then
                        lint.try_lint()
                    end
                end, 500)
            end,
            desc = "Trigger linting after text change (debounced)",
        })

        -- ====================================================================
        -- USER COMMANDS
        -- ====================================================================

        -- Manual lint command
        vim.api.nvim_create_user_command("Lint", function()
            lint.try_lint()
            vim.notify("Linting...", vim.log.levels.INFO)
        end, { desc = "Trigger linting for current buffer" })

        -- Show available linters for current filetype
        vim.api.nvim_create_user_command("LintInfo", function()
            local ft = vim.bo.filetype
            local linters = lint.linters_by_ft[ft] or {}

            if #linters == 0 then
                vim.notify(
                    string.format("No linters configured for filetype: %s", ft),
                    vim.log.levels.WARN
                )
                return
            end

            local available = {}
            local missing = {}

            for _, linter_name in ipairs(linters) do
                local linter = lint.linters[linter_name]
                if linter then
                    local cmd = linter.cmd
                    if vim.fn.executable(cmd) == 1 then
                        table.insert(available, linter_name)
                    else
                        table.insert(missing, linter_name .. " (" .. cmd .. ")")
                    end
                end
            end

            local message = string.format("Linters for %s:\n\n", ft)

            if #available > 0 then
                message = message .. "✅ Available: " .. table.concat(available, ", ") .. "\n"
            end

            if #missing > 0 then
                message = message .. "❌ Missing: " .. table.concat(missing, ", ") .. "\n"
            end

            vim.notify(message, vim.log.levels.INFO, { title = "nvim-lint" })
        end, { desc = "Show linter info for current filetype" })

        -- ====================================================================
        -- INTEGRATION WITH DIAGNOSTICS
        -- ====================================================================
        -- nvim-lint automatically uses vim.diagnostic to show linting errors
        -- They appear alongside LSP diagnostics in the same UI

        -- Configure diagnostic display (complements LSP config)
        vim.diagnostic.config({
            virtual_text = {
                source = "if_many",  -- Show source when multiple sources exist
                prefix = "●",
            },
            signs = true,
            underline = true,
            severity_sort = true,
            float = {
                source = "always",
                border = "rounded",
            },
        })

        -- ====================================================================
        -- HELPER FUNCTIONS
        -- ====================================================================

        -- Get active linters for statusline
        _G.get_linters = function()
            local ft = vim.bo.filetype
            local linters = lint.linters_by_ft[ft] or {}

            if #linters == 0 then
                return ""
            end

            -- Check which linters are actually available
            local active = {}
            for _, linter_name in ipairs(linters) do
                local linter = lint.linters[linter_name]
                if linter and vim.fn.executable(linter.cmd) == 1 then
                    table.insert(active, linter_name)
                end
            end

            if #active == 0 then
                return ""
            end

            return " " .. table.concat(active, ",")
        end
    end,
}

-- ============================================================================
-- USAGE GUIDE
-- ============================================================================
--
-- COMMANDS:
--   :Lint       - Manually trigger linting
--   :LintInfo   - Show which linters are configured and available
--
-- AUTO-LINTING:
--   Automatically runs on:
--   - Buffer enter
--   - Save (BufWritePost)
--   - Leave insert mode
--   - Text changed (debounced 500ms)
--
-- INSTALL LINTERS:
--   Python:
--     pip install pylint flake8 mypy
--
--   JavaScript/TypeScript:
--     npm install -g eslint
--     # Also need eslint config in project:
--     npm init @eslint/config
--
--   Lua:
--     luarocks install luacheck
--     # Or: brew install luacheck
--
--   Shell:
--     sudo apt install shellcheck  # Linux
--     brew install shellcheck      # macOS
--
--   Markdown:
--     npm install -g markdownlint-cli
--
--   YAML:
--     pip install yamllint
--
--   JSON:
--     npm install -g jsonlint
--
--   Docker:
--     brew install hadolint  # macOS
--     # Or download: https://github.com/hadolint/hadolint/releases
--
--   Go:
--     go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
--
--   SQL:
--     pip install sqlfluff
--
-- DIAGNOSTICS:
--   Linter errors appear alongside LSP diagnostics:
--   - In sign column (gutter)
--   - As virtual text at end of line
--   - In diagnostic float (<leader>e)
--   - In location list (:lopen)
--
-- STATUSLINE INTEGRATION:
--   Add to your statusline:
--     %{v:lua.get_linters()}
--
-- DISABLE SPECIFIC LINTERS:
--   In your config:
--     require("lint").linters_by_ft.python = { "pylint" }  -- Only use pylint
--
-- PROJECT-SPECIFIC CONFIG:
--   Most linters support project config files:
--   - Pylint: .pylintrc or pyproject.toml
--   - Flake8: .flake8 or setup.cfg
--   - ESLint: .eslintrc.json
--   - Shellcheck: .shellcheckrc
--   - Luacheck: .luacheckrc
--
-- ============================================================================
