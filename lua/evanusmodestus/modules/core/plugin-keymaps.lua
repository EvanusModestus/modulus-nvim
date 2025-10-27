-- All plugin keymaps in one place, loaded after plugins
local M = {}

function M.setup()
    -- Telescope
    local telescope_ok, telescope_builtin = pcall(require, 'telescope.builtin')
    if telescope_ok then
        vim.keymap.set('n', '<leader>pf', telescope_builtin.find_files, { desc = "Find files" })
        vim.keymap.set('n', '<C-p>', telescope_builtin.git_files, { desc = "Git files" })
        vim.keymap.set('n', '<leader>ps', function()
            telescope_builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "Grep search" })
        vim.keymap.set('n', '<leader>vh', telescope_builtin.help_tags, { desc = "Help tags" })
        vim.keymap.set('n', '<leader>pb', telescope_builtin.buffers, { desc = "Find buffers" })
        vim.keymap.set('n', '<leader>po', telescope_builtin.oldfiles, { desc = "Recent files" })
        vim.keymap.set('n', '<leader>/', telescope_builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set('n', '<leader>?', telescope_builtin.current_buffer_fuzzy_find, { desc = "Buffer search" })
    end

    -- Harpoon
    local harpoon_mark_ok, mark = pcall(require, "harpoon.mark")
    local harpoon_ui_ok, ui = pcall(require, "harpoon.ui")
    if harpoon_mark_ok and harpoon_ui_ok then
        vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Add to harpoon" })
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon menu" })
        vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end, { desc = "Harpoon file 1" })
        vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end, { desc = "Harpoon file 2" })
        vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end, { desc = "Harpoon file 3" })
        vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end, { desc = "Harpoon file 4" })
    end

    -- Fugitive
    -- Removed: <leader>gs - using telescope git_status instead (works from oil buffers)
    -- To use fugitive directly, just type :Git
    vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
    vim.keymap.set("n", "<leader>gP", ":Git pull --rebase<CR>", { desc = "Git pull rebase" })

    -- Undotree
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })

    -- Refactoring
    local refactoring_ok, refactoring = pcall(require, 'refactoring')
    if refactoring_ok then
        vim.keymap.set("x", "<leader>re", ":Refactor extract ")
        vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
        vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
        vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
        vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")
        vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
        vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
    end

    -- DAP (Debugging)
    local dap_ok, dap = pcall(require, 'dap')
    if dap_ok then
        vim.keymap.set('n', '<F5>', dap.continue, { desc = "Debug: Continue" })
        vim.keymap.set('n', '<F10>', dap.step_over, { desc = "Debug: Step Over" })
        vim.keymap.set('n', '<F11>', dap.step_into, { desc = "Debug: Step Into" })
        vim.keymap.set('n', '<F12>', dap.step_out, { desc = "Debug: Step Out" })
        vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set('n', '<leader>B', function()
            dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end, { desc = "Conditional Breakpoint" })
        vim.keymap.set('n', '<leader>lp', function()
            dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
        end, { desc = "Log Point" })
        vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = "Debug REPL" })
        vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = "Debug Last" })
    end

    -- DAP UI
    local dapui_ok, dapui = pcall(require, 'dapui')
    if dapui_ok then
        vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = "Toggle Debug UI" })
    end

    -- Zen Mode
    vim.keymap.set("n", "<leader>zz", function()
        require("zen-mode").toggle({ window = { width = 90 } })
    end, { desc = "Zen mode" })

    -- Cellular Automaton
    vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain!" })

    -- ToggleTerm
    vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = "Toggle terminal" })
    vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = "Float terminal" })
    vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<CR>', { desc = "Horizontal terminal" })
    vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', { desc = "Vertical terminal" })

    -- Markdown Preview
    vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle markdown preview" })

    -- Lazygit
    vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })

    -- Glow markdown preview
    vim.keymap.set("n", "<leader>mg", "<cmd>Glow<CR>", { desc = "Glow markdown preview" })

    -- Database UI
    vim.keymap.set("n", "<leader>db", "<cmd>DBUI<CR>", { desc = "Database UI" })

    -- LuaSnip - Jump through snippet placeholders
    local luasnip_ok, luasnip = pcall(require, 'luasnip')
    if luasnip_ok then
        vim.keymap.set({'i', 's'}, '<C-j>', function()
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            end
        end, { desc = "LuaSnip: Jump to next placeholder" })

        vim.keymap.set({'i', 's'}, '<C-k>', function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, { desc = "LuaSnip: Jump to previous placeholder" })
    end
end

return M