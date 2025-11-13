-- Treesitter configuration
-- Syntax highlighting and parsing

local M = {}

function M.setup()
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
        return
    end

    configs.setup {
        ensure_installed = {
            "javascript", "typescript", "c", "lua", "rust", "vim", "vimdoc", "query",
            "markdown", "markdown_inline", "yaml", "xml", "json", "toml", "bash",
            "python", "dockerfile", "sql", "css", "html", "regex", "http", "csv"
        },

        sync_install = false,
        auto_install = true,

        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }
end

return M