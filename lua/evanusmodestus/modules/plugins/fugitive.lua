-- Fugitive git plugin configuration and keymaps
-- Git integration for Vim

local M = {}

function M.keymaps()
    -- Removed: <leader>gs conflicts with telescope git_status (works from oil buffers)
    -- Use telescope's <leader>gs instead, or :Git for fugitive
end

return M