-- Simple REST client for Neovim
local M = {}

function M.setup()
    -- Autocommand for .http files
    vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        pattern = {"*.http", "*.rest"},
        callback = function()
            vim.bo.filetype = "http"

            -- Set keymaps for this buffer
            vim.keymap.set('n', '<CR>', function() M.execute_request() end,
                { buffer = true, desc = "Execute HTTP request" })
            vim.keymap.set('n', '<C-j>', function() M.execute_request() end,
                { buffer = true, desc = "Execute HTTP request" })
        end,
    })
end

function M.execute_request()
    -- Get current line
    local line = vim.api.nvim_get_current_line()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local all_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Find request block
    local method = "GET"
    local url = nil
    local headers = {}
    local body = ""

    -- Search for request start
    local start_line = cursor[1]
    for i = cursor[1], 1, -1 do
        local l = all_lines[i]
        if l:match("^GET ") or l:match("^POST ") or l:match("^PUT ") or
           l:match("^DELETE ") or l:match("^PATCH ") or l:match("^https?://") then
            start_line = i
            break
        end
        if l:match("^###") or l:match("^--") then
            start_line = i + 1
            break
        end
    end

    -- Parse request from start_line
    local in_body = false
    for i = start_line, #all_lines do
        local l = all_lines[i]

        -- Stop at separator
        if i > start_line and (l:match("^###") or l:match("^--")) then
            break
        end

        if not in_body then
            -- Parse method and URL
            if l:match("^%u+ https?://") then
                method, url = l:match("^(%u+) (.+)")
            elseif l:match("^https?://") then
                url = l
                method = "GET"
            -- Parse headers
            elseif l:match("^[%w-]+: ") then
                local key, value = l:match("^([%w-]+): (.+)")
                headers[key] = value
            -- Empty line = body starts
            elseif l == "" and url then
                in_body = true
            end
        else
            -- Collect body
            if body == "" then
                body = l
            else
                body = body .. "\n" .. l
            end
        end
    end

    if not url then
        vim.notify("No URL found", vim.log.levels.ERROR)
        return
    end

    -- Build curl command
    local cmd = {"curl", "-s", "-i", "-X", method}

    -- Add headers
    for k, v in pairs(headers) do
        table.insert(cmd, "-H")
        table.insert(cmd, k .. ": " .. v)
    end

    -- Add body
    if body ~= "" then
        table.insert(cmd, "-d")
        table.insert(cmd, body)
    end

    -- Add URL
    table.insert(cmd, url)

    -- Execute request
    vim.notify("Executing: " .. method .. " " .. url)

    local result = vim.fn.system(cmd)

    -- Display result in split
    vim.cmd("vsplit __REST_Response__")
    local result_buf = vim.api.nvim_get_current_buf()
    vim.bo[result_buf].buftype = "nofile"
    vim.bo[result_buf].swapfile = false

    -- Parse and display response
    local lines = vim.split(result, "\n")
    vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, lines)

    -- Go back to original window
    vim.cmd("wincmd p")
end

return M