-- Auto-session configuration
-- Session management

local M = {}

function M.setup()
    local status_ok, auto_session = pcall(require, "auto-session")
    if not status_ok then
        return
    end

    -- Only save sessions, don't auto-restore them
    auto_session.setup({
        auto_restore = false,  -- Don't restore session on startup
        auto_save = true,      -- Still save sessions when exiting
        auto_create = false,   -- Don't create session for new directories
    })
end

return M