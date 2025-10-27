-- Which-key configuration (v3.x API)
-- Keybinding helper and documentation

local M = {}

function M.setup()
    local status_ok, which_key = pcall(require, "which-key")
    if not status_ok then
        return
    end

    -- Modern which-key v3.x setup
    which_key.setup({
        delay = 300,  -- Delay before showing popup (ms)
        preset = "modern",

        -- Window settings
        win = {
            border = "rounded",
            padding = { 1, 2 },
        },

        -- Layout
        layout = {
            width = { min = 20 },
            spacing = 3,
        },

        -- Show help and keys
        show_help = true,
        show_keys = true,
    })

    -- Add key group descriptions using modern API
    which_key.add({
        -- Project mappings (Primeagen style)
        { "<leader>p", group = "Project" },
        { "<leader>pf", desc = "Find Files" },
        { "<leader>ps", desc = "Project Search" },
        { "<leader>pb", desc = "Project Buffers" },
        { "<leader>po", desc = "Recent Files" },

        -- Search mappings
        { "<leader>/", desc = "Live Grep" },
        { "<leader>?", desc = "Buffer Search" },

        -- Vim/Help
        { "<leader>v", group = "Vim" },
        { "<leader>vh", desc = "Help Tags" },

        -- Git operations
        { "<leader>g", group = "Git" },
        { "<leader>gs", desc = "Git Status" },
        { "<leader>gp", desc = "Git Push" },
        { "<leader>gP", desc = "Git Pull Rebase" },
        { "<leader>lg", desc = "LazyGit" },

        -- Debug/Database
        { "<leader>d", group = "Debug/Database" },
        { "<leader>db", desc = "Database UI" },
        { "<leader>du", desc = "Debug UI" },
        { "<leader>b", desc = "Toggle Breakpoint" },
        { "<leader>B", desc = "Conditional Breakpoint" },

        -- Terminal/Toggle
        { "<leader>t", group = "Terminal" },
        { "<leader>tt", desc = "Toggle Terminal" },
        { "<leader>tf", desc = "Float Terminal" },
        { "<leader>th", desc = "Horizontal Terminal" },
        { "<leader>tv", desc = "Vertical Terminal" },

        -- Markdown/Make
        { "<leader>m", group = "Markdown/Make" },
        { "<leader>mp", desc = "Markdown Preview" },
        { "<leader>mg", desc = "Glow Preview" },
        { "<leader>mr", desc = "Make it Rain!" },

        -- Refactoring
        { "<leader>r", group = "Refactoring" },

        -- Other mappings
        { "<leader>u", desc = "Undotree" },
        { "<leader>a", desc = "Add to Harpoon" },
        { "<leader>z", group = "Zen" },
        { "<leader>zz", desc = "Zen Mode" },

        -- Harpoon (Ctrl keys)
        { "<C-e>", desc = "Harpoon Menu" },
        { "<C-h>", desc = "Harpoon File 1" },
        { "<C-t>", desc = "Harpoon File 2" },
        { "<C-n>", desc = "Harpoon File 3" },
        { "<C-s>", desc = "Harpoon File 4" },
        { "<C-p>", desc = "Git Files" },

        -- Debug function keys
        { "<F5>", desc = "Debug: Continue" },
        { "<F10>", desc = "Debug: Step Over" },
        { "<F11>", desc = "Debug: Step Into" },
        { "<F12>", desc = "Debug: Step Out" },
    })
end

return M