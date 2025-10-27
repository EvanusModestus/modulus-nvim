-- Harpoon configuration and keymaps
-- Quick file navigation and bookmarking

local M = {}

function M.keymaps()
    local status_ok_mark, mark = pcall(require, "harpoon.mark")
    local status_ok_ui, ui = pcall(require, "harpoon.ui")

    if not status_ok_mark or not status_ok_ui then
        return
    end

    vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Add file to harpoon" })
    vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle harpoon menu" })

    vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end, { desc = "Harpoon file 1" })
    vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end, { desc = "Harpoon file 2" })
    vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end, { desc = "Harpoon file 3" })
    vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end, { desc = "Harpoon file 4" })
end

return M