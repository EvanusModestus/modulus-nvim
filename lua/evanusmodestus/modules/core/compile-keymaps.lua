-- Compilation keymaps for various languages
local M = {}

function M.setup()
    -- C/C++ compile keymaps
    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'c', 'cpp' },
        callback = function()
            if vim.bo.filetype == 'c' then
                vim.keymap.set('n', '<leader>cc', ':w<CR>:!gcc -Wall -g -o "%:p:r" "%:p" -lm<CR>',
                    { buffer = true, silent = false, desc = '[C] Compile' })
                vim.keymap.set('n', '<leader>cr', ':w<CR>:!gcc -Wall -g -o "%:p:r" "%:p" -lm && "%:p:r"<CR>',
                    { buffer = true, silent = false, desc = '[C] Compile & Run' })
            elseif vim.bo.filetype == 'cpp' then
                vim.keymap.set('n', '<leader>cc', ':w<CR>:!g++ -Wall -g -std=c++17 -o "%:p:r" "%:p"<CR>',
                    { buffer = true, silent = false, desc = '[C++] Compile' })
                vim.keymap.set('n', '<leader>cr', ':w<CR>:!g++ -Wall -g -std=c++17 -o "%:p:r" "%:p" && "%:p:r"<CR>',
                    { buffer = true, silent = false, desc = '[C++] Compile & Run' })
                vim.keymap.set('n', '<leader>cpp', ':w<CR>:!g++ -Wall -g -std=c++17 -o "%:p:r" "%:p"<CR>',
                    { buffer = true, silent = false, desc = '[C++] Compile (alt)' })
            end

            -- Execute without compile
            vim.keymap.set('n', '<leader>ce', ':!"%:p:r"<CR>',
                { buffer = true, silent = false, desc = '[Exec] Run binary' })

            -- Makefile support for C/C++ projects
            vim.keymap.set('n', '<leader>cm', ':w<CR>:!make<CR>',
                { buffer = true, silent = false, desc = '[Make] Build project' })
            vim.keymap.set('n', '<leader>cM', ':w<CR>:!make clean && make<CR>',
                { buffer = true, silent = false, desc = '[Make] Clean & rebuild' })
        end,
    })

    -- Python keymaps
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function()
            vim.keymap.set('n', '<leader>cr', ':w<CR>:!python3 "%:p"<CR>',
                { buffer = true, silent = false, desc = '[Python] Run' })
            vim.keymap.set('n', '<leader>ct', ':w<CR>:!python3 -m pytest "%:p"<CR>',
                { buffer = true, silent = false, desc = '[Python] Test with pytest' })
        end,
    })

    -- Rust keymaps
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'rust',
        callback = function()
            -- Check if in a Cargo project
            local cargo_exists = vim.fn.findfile('Cargo.toml', '.;') ~= ''

            if cargo_exists then
                -- Cargo project keymaps
                vim.keymap.set('n', '<leader>cr', ':w<CR>:!cargo run<CR>',
                    { buffer = true, silent = false, desc = '[Rust] Cargo run' })
                vim.keymap.set('n', '<leader>ct', ':w<CR>:!cargo test<CR>',
                    { buffer = true, silent = false, desc = '[Rust] Cargo test' })
                vim.keymap.set('n', '<leader>cb', ':w<CR>:!cargo build<CR>',
                    { buffer = true, silent = false, desc = '[Rust] Cargo build' })
            else
                -- Standalone Rust file keymaps
                vim.keymap.set('n', '<leader>cc', ':w<CR>:!rustc "%:p" -o "%:p:r"<CR>',
                    { buffer = true, silent = false, desc = '[Rust] Compile with rustc' })
                vim.keymap.set('n', '<leader>cr', ':w<CR>:!rustc "%:p" -o "%:p:r" && "%:p:r"<CR>',
                    { buffer = true, silent = false, desc = '[Rust] Compile & Run' })
                vim.keymap.set('n', '<leader>ce', ':!"%:p:r"<CR>',
                    { buffer = true, silent = false, desc = '[Rust] Execute binary' })
                vim.keymap.set('n', '<leader>ct', ':w<CR>:!rustc --test "%:p" -o "%:p:r_test" && "%:p:r_test"<CR>',
                    { buffer = true, silent = false, desc = '[Rust] Compile & Test' })
            end
        end,
    })

    -- Go keymaps
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'go',
        callback = function()
            vim.keymap.set('n', '<leader>cr', ':w<CR>:!go run "%:p"<CR>',
                { buffer = true, silent = false, desc = '[Go] Run' })
            vim.keymap.set('n', '<leader>ct', ':w<CR>:!go test<CR>',
                { buffer = true, silent = false, desc = '[Go] Test' })
            vim.keymap.set('n', '<leader>cb', ':w<CR>:!go build<CR>',
                { buffer = true, silent = false, desc = '[Go] Build' })
        end,
    })

    -- JavaScript/TypeScript keymaps
    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'javascript', 'typescript' },
        callback = function()
            local opts = { buffer = true, silent = false }
            if vim.bo.filetype == 'javascript' then
                vim.keymap.set('n', '<leader>cr', ':w<CR>:!node "%:p"<CR>',
                    { buffer = true, silent = false, desc = '[JS] Run with node' })
            else
                vim.keymap.set('n', '<leader>cr', ':w<CR>:!ts-node "%:p"<CR>',
                    { buffer = true, silent = false, desc = '[TS] Run with ts-node' })
            end
            vim.keymap.set('n', '<leader>ct', ':w<CR>:!npm test<CR>',
                { buffer = true, silent = false, desc = '[npm] Run tests' })
        end,
    })

    -- Java keymaps
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
            vim.keymap.set('n', '<leader>cc', ':w<CR>:!javac "%:p"<CR>',
                { buffer = true, silent = false, desc = '[Java] Compile' })
            vim.keymap.set('n', '<leader>cr', ':w<CR>:!javac "%:p" && java %:t:r<CR>',
                { buffer = true, silent = false, desc = '[Java] Compile & Run' })
        end,
    })

    -- Makefile support (global keymaps for non-C/C++ files)
    -- For C/C++ files, these are set as buffer-local above
    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'makefile', 'Makefile', 'mk', 'mak' },
        callback = function()
            vim.keymap.set('n', '<leader>cm', ':w<CR>:!make<CR>',
                { buffer = true, silent = false, desc = '[Make] Build project' })
            vim.keymap.set('n', '<leader>cM', ':w<CR>:!make clean && make<CR>',
                { buffer = true, silent = false, desc = '[Make] Clean & rebuild' })
        end,
    })
end

-- Lua keymaps
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function()
        vim.keymap.set('n', '<leader>cr', ':w<CR>:!lua "%:p"<CR>',
            { buffer = true, silent = false, desc = '[Lua] Run' })
        vim.keymap.set('n', '<leader>cs', ':w<CR>:source %<CR>',
            { buffer = true, silent = false, desc = '[Lua] Source in Neovim' })
    end,
})

return M

