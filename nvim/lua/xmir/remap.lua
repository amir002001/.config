vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move current line one down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- move current line one up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- append next line to current line without moving cursor
-- mz - add mark to register z
-- J - join as usual
-- `z - go to the mark set
vim.keymap.set("n", "J", "mzJ`z")

-- make moving up and down center page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- make it so moving in search with n, N recenters page
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
-- makes it so pasting in visual mode deletes into void register
vim.keymap.set("x", "<leader>p", "\"_dP")

-- next greatest remap ever : asbjornHaland
-- yank to clipboard in normal mode
vim.keymap.set("n", "<leader>y", "\"+y")
-- yank to clipboard in visual mode
vim.keymap.set("v", "<leader>y", "\"+y")
-- yank the whole line into clipboard
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- delete into blackhole register
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

-- capital Q don't do jack
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)

-- quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- black magic
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
-- adds execute priv to this file!!
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- LSP FORMAT ON SAVE
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
