local M = {}

function M.setup()
    require("oil").setup({
        -- Basic configuration options
        default_file_sort = "name", -- Sort files by name
        show_hidden = false,        -- Do not show hidden files by default
        window = {
            width = 40,             -- Set window width
            winblend = 0,           -- No transparency
        },
        -- For more options, see: https://github.com/stevearc/oil.nvim
    })

    M.keymaps()
end

function M.keymaps()
    -- Add keybindings to open oil
    vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

return M
