-- LSP Debug Utilities
local M = {}

-- Check if lua_ls has properly indexed vim.api functions
function M.check_vim_api_completion()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })

    for _, client in ipairs(clients) do
        if client.name == "lua_ls" then
            print("✓ lua_ls is attached")

            -- Check if completion provider is available
            if client.server_capabilities.completionProvider then
                print("✓ Completion provider is available")
                print("  Trigger characters:", vim.inspect(
                    client.server_capabilities.completionProvider.triggerCharacters
                ))
            else
                print("✗ No completion provider!")
            end

            -- Try to get workspace symbols for vim.api
            vim.lsp.buf_request(0, 'workspace/symbol',
                { query = 'nvim_buf_get_lines' },
                function(err, result)
                    if result and #result > 0 then
                        print("✓ lua_ls has indexed vim.api.nvim_* functions!")
                        print("  Found " .. #result .. " matching symbols")
                    else
                        print("✗ lua_ls hasn't indexed vim.api.nvim_* functions")
                        print("  This is the core issue to fix")
                    end
                end
            )

            return
        end
    end

    print("✗ lua_ls is not attached to this buffer")
end

-- Create user command for easy debugging
vim.api.nvim_create_user_command('CheckLuaCompletion', function()
    M.check_vim_api_completion()
end, { desc = "Check if lua_ls has vim.api completions" })

-- Monitor completion requests (useful for debugging)
function M.monitor_completion_requests()
    local original = vim.lsp.handlers["textDocument/completion"]

    vim.lsp.handlers["textDocument/completion"] = function(err, result, ctx, config)
        if result then
            local items = result.items or result
            print(string.format("[LSP Completion] Received %d items from %s",
                #items,
                vim.lsp.get_client_by_id(ctx.client_id).name
            ))

            -- Show first few vim.api related completions
            for i, item in ipairs(items) do
                if i <= 5 and item.label:match("^nvim_") then
                    print("  - " .. item.label .. " (" .. (item.kind or "?") .. ")")
                end
            end
        end

        return original(err, result, ctx, config)
    end

    print("Monitoring completion requests... (type vim.api.nvim_ to test)")
end

-- Export module
return M
