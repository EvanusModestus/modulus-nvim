-- Colorscheme configuration
-- Rose Pine theme with transparency
local M = {}

function ColorMyPencils(color)
    color = color or 'rose-pine'
    vim.cmd.colorscheme(color)

    -- Transparency
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

    -- Custom Visual mode highlight - blue
    vim.api.nvim_set_hl(0, 'Visual', {
        bg = '#264f78', -- VSCode blue
        fg = 'none'
    })
end

function M.setup()
    -- Set the colorscheme and apply transparency
    ColorMyPencils()
end

return M
