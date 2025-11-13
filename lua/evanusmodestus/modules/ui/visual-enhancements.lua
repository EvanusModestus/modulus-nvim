-- Visual enhancement plugins
-- Highlighting, indentation guides, and other visual improvements

local M = {}

function M.setup()
    -- Highlighted yank setup
    local status_ok_yank, _ = pcall(require, "vim-highlightedyank")
    if status_ok_yank then
        vim.g.highlightedyank_highlight_duration = 200
    end

    -- Illuminate setup
    local status_ok_illuminate, illuminate = pcall(require, "illuminate")
    if status_ok_illuminate then
        illuminate.configure({
            delay = 200,
            large_file_cutoff = 2000,
        })
    end

    -- Indent blankline setup
    local status_ok_indent, ibl = pcall(require, "ibl")
    if status_ok_indent then
        ibl.setup()
    end
end

return M