-- Telescope configuration and keymaps
-- File finder, live grep, and fuzzy finder

local M = {}

function M.setup()
    local status_ok, telescope = pcall(require, "telescope")
    if not status_ok then
        return
    end

    telescope.setup({
        defaults = {
            file_ignore_patterns = { "node_modules", ".git/" },
            layout_strategy = "flex",
            layout_config = {
                flex = { flip_columns = 120 },
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
        },
    })

    -- Load extensions
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'file_browser')
    pcall(telescope.load_extension, 'project')
    pcall(telescope.load_extension, 'undo')
end

function M.keymaps()
    local builtin = require('telescope.builtin')

    -- Core mappings
    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find files" })
    vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Git files" })
    vim.keymap.set('n', '<leader>ps', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = "Grep search" })
    vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Help tags" })

    -- Additional powerful mappings
    vim.keymap.set('n', '<leader>pr', builtin.resume, { desc = "Resume last search" })
    vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "Find buffers" })
    vim.keymap.set('n', '<leader>po', builtin.oldfiles, { desc = "Recent files" })
    vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set('n', '<leader>pd', builtin.diagnostics, { desc = "Diagnostics" })
    vim.keymap.set('n', '<leader>pc', builtin.commands, { desc = "Commands" })
    vim.keymap.set('n', '<leader>pk', builtin.keymaps, { desc = "Keymaps" })
    vim.keymap.set('n', '<leader>pt', builtin.treesitter, { desc = "Treesitter symbols" })

    -- Git integration
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = "Git commits" })
    vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = "Git branches" })
    vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = "Git status" })

    -- Extension mappings
    vim.keymap.set('n', '<leader>fb', ':Telescope file_browser<CR>', { desc = "File browser" })
    vim.keymap.set('n', '<leader>fp', ':Telescope project<CR>', { desc = "Projects" })
    vim.keymap.set('n', '<leader>fu', ':Telescope undo<CR>', { desc = "Undo tree" })
end

return M