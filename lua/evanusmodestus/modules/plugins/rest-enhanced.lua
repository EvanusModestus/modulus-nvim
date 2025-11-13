-- Enhanced REST client with features for Cisco/Enterprise APIs
local M = {}

-- Store credentials and base URLs
M.env = {}

-- Load environment variables from .env.http file
function M.load_env()
    local env_file = vim.fn.getcwd() .. "/.env.http"
    if vim.fn.filereadable(env_file) == 1 then
        for line in io.lines(env_file) do
            local key, value = line:match("^([^=]+)=(.+)$")
            if key and value then
                M.env[key] = value
            end
        end
        vim.notify("Loaded environment from .env.http", vim.log.levels.INFO)
    end
end

-- Replace variables in text
function M.replace_vars(text)
    if not text then return text end

    -- Replace {{variable}} with env values
    text = text:gsub("{{([^}]+)}}", function(key)
        return M.env[key] or ("{{" .. key .. "}}")
    end)

    -- Replace $variable with env values
    text = text:gsub("$([%w_]+)", function(key)
        return M.env[key] or ("$" .. key)
    end)

    return text
end

-- Save response to file
function M.save_response(response, request_name)
    local responses_dir = vim.fn.getcwd() .. "/http_responses"
    vim.fn.mkdir(responses_dir, "p")

    local timestamp = os.date("%Y%m%d_%H%M%S")
    local filename = string.format("%s/%s_%s.json", responses_dir, request_name, timestamp)

    local file = io.open(filename, "w")
    if file then
        file:write(response)
        file:close()
        vim.notify("Response saved to " .. filename, vim.log.levels.INFO)
    end
end

-- Parse response and extract token (for Cisco APIs that return tokens)
function M.extract_token(response, token_field)
    -- Try to find token in JSON response
    local token = response:match('"' .. token_field .. '"%s*:%s*"([^"]+)"')
    if token then
        M.env.token = token
        M.env.TOKEN = token
        vim.notify("Token extracted and saved to environment", vim.log.levels.INFO)
        return token
    end
    return nil
end

-- Enhanced request execution
function M.execute_request(save_response)
    -- Load environment variables
    M.load_env()

    -- Get current line and buffer
    local line = vim.api.nvim_get_current_line()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local all_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Find request block (same as before)
    local method = "GET"
    local url = nil
    local headers = {}
    local body = ""
    local request_name = "request"

    -- Search for request start
    local start_line = cursor[1]
    for i = cursor[1], 1, -1 do
        local l = all_lines[i]

        -- Check for request name comment
        if l:match("^#%s*@name%s+(.+)") then
            request_name = l:match("^#%s*@name%s+(.+)")
        end

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
                url = M.replace_vars(url)
            elseif l:match("^https?://") then
                url = M.replace_vars(l)
                method = "GET"
            -- Parse headers
            elseif l:match("^[%w-]+: ") then
                local key, value = l:match("^([%w-]+): (.+)")
                headers[key] = M.replace_vars(value)
            -- Empty line = body starts
            elseif l == "" and url then
                in_body = true
            end
        else
            -- Collect body
            if body == "" then
                body = M.replace_vars(l)
            else
                body = body .. "\n" .. M.replace_vars(l)
            end
        end
    end

    if not url then
        vim.notify("No URL found", vim.log.levels.ERROR)
        return
    end

    -- Build curl command with additional options
    local cmd = {"curl", "-s", "-i", "-X", method}

    -- Add --insecure for self-signed certificates (common in Cisco labs)
    if M.env.INSECURE == "true" then
        table.insert(cmd, "--insecure")
    end

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

    -- Extract token if specified
    if M.env.EXTRACT_TOKEN then
        M.extract_token(result, M.env.EXTRACT_TOKEN)
    end

    -- Save response if requested
    if save_response then
        M.save_response(result, request_name)
    end

    -- Display result in split
    vim.cmd("vsplit __REST_Response__")
    local result_buf = vim.api.nvim_get_current_buf()
    vim.bo[result_buf].buftype = "nofile"
    vim.bo[result_buf].swapfile = false
    vim.bo[result_buf].filetype = "http"

    -- Parse and display response with pretty JSON
    local lines = vim.split(result, "\n")
    local formatted_lines = {}
    local in_json = false
    local json_body = ""

    for _, line in ipairs(lines) do
        if not in_json and (line:match("^%s*{") or line:match("^%s*%[")) then
            in_json = true
            json_body = line
        elseif in_json then
            json_body = json_body .. "\n" .. line
        else
            table.insert(formatted_lines, line)
        end
    end

    -- Try to format JSON with jq
    if json_body ~= "" then
        local pretty_json = vim.fn.system("jq '.' 2>/dev/null", json_body)
        if vim.v.shell_error == 0 then
            table.insert(formatted_lines, "")
            for _, line in ipairs(vim.split(pretty_json, "\n")) do
                table.insert(formatted_lines, line)
            end
        else
            -- Fallback to original JSON
            for _, line in ipairs(vim.split(json_body, "\n")) do
                table.insert(formatted_lines, line)
            end
        end
    end

    vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, formatted_lines)

    -- Go back to original window
    vim.cmd("wincmd p")
end

function M.setup()
    -- Autocommand for .http files
    vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        pattern = {"*.http", "*.rest"},
        callback = function()
            vim.bo.filetype = "http"

            -- Set keymaps for this buffer
            vim.keymap.set('n', '<CR>', function() M.execute_request(false) end,
                { buffer = true, desc = "Execute HTTP request" })
            vim.keymap.set('n', '<C-j>', function() M.execute_request(false) end,
                { buffer = true, desc = "Execute HTTP request" })
            vim.keymap.set('n', '<leader>hs', function() M.execute_request(true) end,
                { buffer = true, desc = "Execute and save response" })
            vim.keymap.set('n', '<leader>he', function() M.load_env() end,
                { buffer = true, desc = "Reload environment variables" })
        end,
    })

    -- Add command to set variables
    vim.api.nvim_create_user_command('HttpSetVar', function(opts)
        local key, value = opts.args:match("^(%S+)%s+(.+)$")
        if key and value then
            M.env[key] = value
            vim.notify(string.format("Set %s = %s", key, value), vim.log.levels.INFO)
        end
    end, { nargs = 1 })
end

return M