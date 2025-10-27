-- Lualine statusline configuration
-- Custom statusline with rose-pine theme

local M = {}

function M.setup()
    local status_ok, lualine = pcall(require, "lualine")
    if not status_ok then
        return
    end

    lualine.setup {
        options = {
            icons_enabled = true,
            theme = 'rose-pine',
            component_separators = '|',
            section_separators = '',
        },
    }
end

return M