-- ToggleTerm configuration and terminal management
-- Floating terminal and compilation terminals

local M = {}

function M.setup()
    local status_ok, toggleterm = pcall(require, "toggleterm")
    if not status_ok then
        return
    end

    toggleterm.setup{
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
            border = "curved",
            winblend = 0,
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        },
    }
end

function M.keymaps()
    local status_ok, Terminal = pcall(require, "toggleterm.terminal")
    if not status_ok then
        return
    end

    -- Lazygit terminal
    local lazygit = Terminal.Terminal:new({ cmd = "lazygit", hidden = true })

    function _LAZYGIT_TOGGLE()
        lazygit:toggle()
    end

    vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", {noremap = true, silent = true, desc = "Toggle Lazygit"})

    -- C/C++ Compilation Terminal
    -- Detect platform and use appropriate shell
    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
    local shell_cmd = is_windows and "pwsh" or vim.o.shell

    local compile_term = Terminal.Terminal:new({
        cmd = shell_cmd,
        hidden = true,
        direction = "horizontal",
        on_open = function(term)
            vim.cmd("startinsert!")
        end,
    })

    function _COMPILE_C()
        local file = vim.fn.expand("%")
        local file_no_ext = vim.fn.expand("%:r")
        if is_windows then
            -- PowerShell syntax
            compile_term:send("gcc -Wall -g " .. file .. " -o " .. file_no_ext .. ".exe")
            compile_term:send("if ($?) { echo 'Compilation successful!'; ./" .. file_no_ext .. ".exe } else { echo 'Compilation failed!' }")
        else
            -- Unix shell syntax (bash/zsh)
            compile_term:send("gcc -Wall -g " .. file .. " -o " .. file_no_ext .. " && echo 'Compilation successful!' && ./" .. file_no_ext .. " || echo 'Compilation failed!'")
        end
        compile_term:open()
    end

    function _COMPILE_CPP()
        local file = vim.fn.expand("%")
        local file_no_ext = vim.fn.expand("%:r")
        if is_windows then
            -- PowerShell syntax
            compile_term:send("g++ -Wall -g -std=c++17 " .. file .. " -o " .. file_no_ext .. ".exe")
            compile_term:send("if ($?) { echo 'Compilation successful!'; ./" .. file_no_ext .. ".exe } else { echo 'Compilation failed!' }")
        else
            -- Unix shell syntax (bash/zsh)
            compile_term:send("g++ -Wall -g -std=c++17 " .. file .. " -o " .. file_no_ext .. " && echo 'Compilation successful!' && ./" .. file_no_ext .. " || echo 'Compilation failed!'")
        end
        compile_term:open()
    end

    -- F6/F7 for compilation (F5/F10/F11/F12 reserved for DAP debugging)
    vim.api.nvim_set_keymap("n", "<F6>", "<cmd>lua _COMPILE_C()<CR>", {noremap = true, silent = true, desc = "Compile and run C"})
    vim.api.nvim_set_keymap("n", "<F7>", "<cmd>lua _COMPILE_CPP()<CR>", {noremap = true, silent = true, desc = "Compile and run C++"})
end

return M