-- Autopairs configuration
-- Automatic bracket and quote pairing

local M = {}

function M.setup()
    local status_ok, autopairs = pcall(require, "nvim-autopairs")
    if not status_ok then
        return
    end

    autopairs.setup {}

    -- Note: nvim-cmp integration removed
    -- blink.cmp has built-in auto-brackets feature
    -- If blink.cmp's auto-brackets conflict with autopairs,
    -- disable one: either autopairs or blink.cmp's auto_brackets
end

return M