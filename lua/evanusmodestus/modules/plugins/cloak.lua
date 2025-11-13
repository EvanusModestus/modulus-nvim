-- Cloak configuration
-- Hide sensitive information in files

local M = {}

function M.setup()
    local status_ok, cloak = pcall(require, "cloak")
    if not status_ok then
        return
    end

    cloak.setup({
        enabled = true,
        cloak_character = "*",
        highlight_group = "Comment",
        patterns = {
            {
                file_pattern = {
                    ".env*",
                    "wrangler.toml",
                    ".dev.vars",
                },
                cloak_pattern = "=.+"
            },
        },
    })
end

return M