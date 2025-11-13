-- Debug Adapter Protocol (DAP) configuration
-- Debugging setup for multiple languages

local M = {}

function M.setup()
    local dap_status_ok, dap = pcall(require, "dap")
    if not dap_status_ok then
        return
    end

    local dapui_status_ok, dapui = pcall(require, "dapui")
    if not dapui_status_ok then
        return
    end

    dapui.setup()

    -- Setup virtual text
    local dap_vt_status_ok, dap_vt = pcall(require, "nvim-dap-virtual-text")
    if dap_vt_status_ok then
        dap_vt.setup()
    end

    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Python debugging
    local dap_python_status_ok, dap_python = pcall(require, "dap-python")
    if dap_python_status_ok then
        dap_python.setup('python3')
    end

    -- C/C++ debugging configuration (auto-detect environment)
    local mason_path = vim.fn.stdpath("data") .. '/mason'

    -- Detect and set appropriate cppdbg adapter
    local cppdbg_exe = mason_path .. '/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7.exe'
    local cppdbg_linux = mason_path .. '/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7'

    if vim.fn.executable(cppdbg_exe) == 1 then
        -- Windows/WSL environment
        dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command = cppdbg_exe,
        }
    elseif vim.fn.executable(cppdbg_linux) == 1 then
        -- Native Linux environment
        dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command = cppdbg_linux,
        }
    end

    -- Detect and set appropriate codelldb adapter
    local codelldb_cmd = mason_path .. '/bin/codelldb.cmd'
    local codelldb_linux = mason_path .. '/bin/codelldb'

    if vim.fn.executable(codelldb_cmd) == 1 then
        -- Windows/WSL environment
        dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
                command = codelldb_cmd,
                args = {"--port", "${port}"},
            }
        }
    elseif vim.fn.executable(codelldb_linux) == 1 then
        -- Native Linux environment
        dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
                command = codelldb_linux,
                args = {"--port", "${port}"},
            }
        }
    end

    -- C/C++ configurations
    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = true,
            setupCommands = {
                {
                    text = '-enable-pretty-printing',
                    description = 'enable pretty printing',
                    ignoreFailures = false
                },
            },
        },
        {
            name = "Launch with CodeLLDB",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
        },
    }

    -- Use same config for C
    dap.configurations.c = dap.configurations.cpp
end

function M.keymaps()
    local status_ok, dap = pcall(require, "dap")
    if not status_ok then
        return
    end

    vim.keymap.set('n', '<F5>', dap.continue, { desc = "DAP Continue" })
    vim.keymap.set('n', '<F10>', dap.step_over, { desc = "DAP Step Over" })
    vim.keymap.set('n', '<F11>', dap.step_into, { desc = "DAP Step Into" })
    vim.keymap.set('n', '<F12>', dap.step_out, { desc = "DAP Step Out" })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = "Conditional Breakpoint" })
end

return M