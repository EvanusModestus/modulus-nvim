-- Autocmds and autocommands migrated from various plugin configurations
-- All autocmds that don't belong to specific plugins

-- Enable spell checking for Markdown files
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})

-- Terminal keymaps - set when entering terminal mode
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = 'term://*',
    callback = function()
        local opts = {noremap = true}
        vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
    end,
})

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({
            higroup = 'Visual',
            timeout = 200,
        })
    end,
})

-- Auto-resize splits when Vim is resized
vim.api.nvim_create_autocmd('VimResized', {
    callback = function()
        vim.cmd('tabdo wincmd =')
    end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function()
        local save_cursor = vim.fn.getpos('.')
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos('.', save_cursor)
    end,
})

-- Auto-create directories when saving files
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        local dir = vim.fn.expand('<afile>:p:h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, 'p')
        end
    end,
})