local M = {}

function M.setup()
    -- Enhanced fold options
    vim.o.foldcolumn = '1'    -- Start minimal, auto-expands when needed
    vim.o.foldlevel = 99      -- Open all folds by default
    vim.o.foldlevelstart = 99 -- Start with all folds open
    vim.o.foldenable = true   -- Enable folding

    -- Nerd Font icons with better spacing
    -- vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldclose:,foldsep: '
    vim.o.fillchars = 'eob: ,fold: ,foldopen:▼,foldclose:▶,foldsep: '

    -- Custom fold highlights for better visibility
    vim.api.nvim_set_hl(0, 'Folded', {
        bg = '#2d2d3d', -- Subtle background
        fg = '#c0caf5', -- Bright text
        italic = true
    })
    vim.api.nvim_set_hl(0, 'FoldColumn', {
        bg = 'none',   -- Transparent
        fg = '#565f89' -- Muted icons
    })

    -- Enhanced fold text handler with dynamic icons
    local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local totalLines = endLnum - lnum

        -- Dynamic icons based on fold size
        local icon
        if totalLines > 100 then
            icon = '󰪥' -- Package icon for huge folds
        elseif totalLines > 50 then
            icon = '' -- Layers for large folds
        else
            icon = '󰡏' -- Minimal for small folds
        end

        -- Format: icon + count (no "lines" text for cleaner look)
        local suffix = (' %s %d '):format(icon, totalLines)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0

        -- Build the virtual text
        for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
                table.insert(newVirtText, chunk)
            else
                chunkText = truncate(chunkText, targetWidth - curWidth)
                local hlGroup = chunk[2]
                table.insert(newVirtText, { chunkText, hlGroup })
                chunkWidth = vim.fn.strdisplaywidth(chunkText)
                -- Add padding
                if curWidth + chunkWidth < targetWidth then
                    suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                end
                break
            end
            curWidth = curWidth + chunkWidth
        end

        -- Dimmed line count for less visual noise
        table.insert(newVirtText, { suffix, 'Comment' })
        return newVirtText
    end

    -- Setup nvim-ufo with enhanced preview
    require('ufo').setup({
        fold_virt_text_handler = handler,

        -- Provider priority: treesitter first, then indent fallback
        provider_selector = function(bufnr, filetype, buftype)
            return { 'treesitter', 'indent' }
        end,

        -- Enhanced preview window
        preview = {
            win_config = {
                border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }, -- Rounded borders
                winhighlight = 'Normal:Folded,FloatBorder:FloatBorder',
                winblend = 5, -- Slight transparency
                maxheight = 20, -- Limit preview height
                maxwidth = 80 -- Limit preview width
            },
            mappings = {
                scrollU = '<C-u>',
                scrollD = '<C-d>',
                jumpTop = '[',
                jumpBot = ']'
            }
        },

        -- Close folds automatically when navigating away
        close_fold_kinds_for_ft = {
            default = { 'imports', 'comment' }
        },
    })

    -- Core keymaps
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
    vim.keymap.set('n', 'zK', require('ufo').peekFoldedLinesUnderCursor, { desc = 'Peek fold' })

    -- Power user keymaps
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Open folds except kinds' })
    vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = 'Close folds with' })

    -- Quick navigation between folds
    vim.keymap.set('n', 'zj', function()
        require('ufo').goNextClosedFold()
    end, { desc = 'Go to next closed fold' })

    vim.keymap.set('n', 'zk', function()
        require('ufo').goPreviousClosedFold()
    end, { desc = 'Go to previous closed fold' })
end

return M
