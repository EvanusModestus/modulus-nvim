-- Comment.nvim configuration
-- Smart commenting plugin

local M = {}

function M.setup()
    local status_ok, comment = pcall(require, "Comment")
    if not status_ok then
        return
    end

    comment.setup({
        toggler = {
            line = 'gcc',
            block = 'gbc',
        },
        opleader = {
            line = 'gc',
            block = 'gb',
        },
    })
end

return M