-- Core keymaps that load immediately
local keymap = vim.keymap.set

-- Window navigation
keymap("n", "<C-h>", ":wincmd h<CR>", { silent = true })
keymap("n", "<C-j>", ":wincmd j<CR>", { silent = true })
keymap("n", "<C-k>", ":wincmd k<CR>", { silent = true })
keymap("n", "<C-l>", ":wincmd l<CR>", { silent = true })

-- Split panes
keymap("n", "<leader>s", ":split<CR>")
keymap("n", "<leader>v", ":vsplit<CR>")

-- Tab motions
keymap("n", "<leader>t", ":tabnew<CR>")
keymap("n", "<leader>l", ":tabnext<CR>")
keymap("n", "<leader>h", ":tabprevious<CR>")

-- Clear search highlighting
keymap("n", "<CR>", ":nohlsearch<CR><CR>", { silent = true })

-- Use very magic mode for search
keymap("n", "/", "/\\v", { silent = false })
keymap("n", "?", "?\\v", { silent = false })
keymap("c", "%s/", "%s/\\v")

-- Better escape in insert and visual mode
keymap("i", "<C-[>", "<Esc>")
keymap("i", "<C-c>", "<Esc>")
keymap("v", "<C-[>", "<Esc>")
keymap("v", "<C-c>", "<Esc>")

-- Escape in command mode
keymap("c", "<C-c>", "<C-C>")
keymap("c", "<C-[>", "<C-C>")

-- Undo mapping
keymap("n", "<C-z>", "u")
