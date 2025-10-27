-- Modular Neovim Configuration
-- Modern, organized, and maintainable setup

-- Core configuration (must be loaded first)
require('evanusmodestus.modules.core.settings')
require('evanusmodestus.modules.core.keymaps')
require('evanusmodestus.modules.core.autocmds')

-- Initialize lazy.nvim with plugins
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins with lazy.nvim
local plugins = require('evanusmodestus.lazy-plugins')
require('lazy').setup(plugins, {
    ui = {
        -- Simple UI, no fancy icons
        icons = {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})

-- Post-plugin setup for modules that need plugins to be loaded
vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
        -- Load ALL plugin keymaps from central location
        vim.defer_fn(function()
            require('evanusmodestus.modules.core.plugin-keymaps').setup()
            require('evanusmodestus.modules.core.compile-keymaps').setup()

            -- Simple REST client for .http files
            require('evanusmodestus.modules.plugins.simple-rest').setup()

            -- Setup visual enhancements
            require('evanusmodestus.modules.ui.visual-enhancements').setup()

            print('All keymaps loaded!')
        end, 100)
    end,
})

---print("Neovim configured! Use :Lazy to manage plugins")

