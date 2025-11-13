-- Colorizer configuration
-- Display colors in code

local M = {}

function M.setup()
    -- Ensure termguicolors is set before loading colorizer
    if not vim.opt.termguicolors:get() then
        vim.opt.termguicolors = true
    end

    local ok, colorizer = pcall(require, 'colorizer')
    if ok then
        colorizer.setup()
    end
end

return M