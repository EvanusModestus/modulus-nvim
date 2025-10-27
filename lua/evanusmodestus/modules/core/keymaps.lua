-- Core keymaps migrated from remap.lua
-- All core keymaps and key bindings

-- Basic navigation and editing
-- Removed: <leader>pv (netrw) - replaced by oil.nvim (<leader>e)

-- Move visual selection up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join lines and keep cursor position
vim.keymap.set("n", "J", "mzJ`z")

-- Half page jumping with centering
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search centering
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without yanking in visual mode
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete to void register
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Better escape mappings
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Disable Q (Ex mode)
vim.keymap.set("n", "Q", "<nop>")

-- Tmux sessionizer (external script)
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- LSP formatting
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Search and replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Edit plugin configuration
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/evanusmodestus/lazy.lua<CR>");

-- Cellular Automaton fun
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

-- Source current file
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("source %")
end)

-- Quick save and quit
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Quick save" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quick quit" })

-- Center screen after searching
vim.keymap.set("n", "*", "*zz", { desc = "Search word and center" })
vim.keymap.set("n", "#", "#zz", { desc = "Search word backward and center" })
vim.keymap.set("n", "g*", "g*zz", { desc = "Search partial word and center" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate down window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate up window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate right window" })

-- Resize windows with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- C/C++ compilation keymaps are now in compile-keymaps.lua for better organization

-- JavaScript/Node.js Development Keybindings
-- Additional npm commands (basic JS run is in compile-keymaps.lua as <leader>cr)
vim.keymap.set("n", "<leader>jd", ":w<CR>:!npm run dev<CR>", { desc = "Run npm dev server" })
vim.keymap.set("n", "<leader>js", ":w<CR>:!npm start<CR>", { desc = "Run npm start" })
vim.keymap.set("n", "<leader>ji", ":!npm install<CR>", { desc = "Run npm install" })
vim.keymap.set("n", "<leader>jb", ":w<CR>:!npm run build<CR>", { desc = "Run npm build" })