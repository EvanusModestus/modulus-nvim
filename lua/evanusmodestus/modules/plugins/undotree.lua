-- Undotree plugin configuration and keymaps
-- Visual undo tree

local M = {}

function M.keymaps()
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
end

return M