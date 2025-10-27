-- Refactoring plugin configuration and keymaps
-- Code refactoring utilities

local M = {}

function M.setup()
    local status_ok, refactoring = pcall(require, "refactoring")
    if not status_ok then
        return
    end

    refactoring.setup({})
end

function M.keymaps()
    -- Refactoring operations
    vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false, desc = "Inline Variable"})
    vim.api.nvim_set_keymap("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], {noremap = true, silent = true, expr = false, desc = "Extract Variable"})
    vim.api.nvim_set_keymap("v", "<leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false, desc = "Extract Function"})

    -- Telescope integration for refactoring
    vim.api.nvim_set_keymap("v", "<leader>rr", [[ <Esc><Cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]], {noremap = true, desc = "Telescope Refactors"})

    -- Debug helpers
    vim.api.nvim_set_keymap("n", "<leader>rp", ":lua require('refactoring').debug.printf({below = false})<CR>", {noremap = true, desc = "Debug Printf"})
    vim.api.nvim_set_keymap("v", "<leader>rv", ":lua require('refactoring').debug.print_var()<CR>", {noremap = true, desc = "Print Variable"})
    vim.api.nvim_set_keymap("n", "<leader>rc", ":lua require('refactoring').debug.cleanup({})<CR>", {noremap = true, desc = "Cleanup Debug"})
end

return M