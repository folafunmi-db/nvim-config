-- Core keymaps that load immediately
local keymap = vim.keymap.set

-- Window navigation (Ctrl+h/j/k/l)
keymap("n", "<C-h>", "<C-w>h", { silent = true, desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { silent = true, desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { silent = true, desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { silent = true, desc = "Move to right window" })
keymap("n", "<M-h>", "<C-w>h", { silent = true, desc = "Move to left window (Alt)" })
keymap("n", "<M-j>", "<C-w>j", { silent = true, desc = "Move to bottom window (Alt)" })
keymap("n", "<M-k>", "<C-w>k", { silent = true, desc = "Move to top window (Alt)" })
keymap("n", "<M-l>", "<C-w>l", { silent = true, desc = "Move to right window (Alt)" })

-- Window navigation (leader-based alternatives)
keymap("n", "<leader>wh", "<C-w>h", { silent = true, desc = "Move to left window" })
keymap("n", "<leader>wj", "<C-w>j", { silent = true, desc = "Move to bottom window" })
keymap("n", "<leader>wk", "<C-w>k", { silent = true, desc = "Move to top window" })
keymap("n", "<leader>wl", "<C-w>l", { silent = true, desc = "Move to right window" })

-- Split panes
keymap("n", "<leader>s", ":split<CR>")
keymap("n", "<leader>v", ":vsplit<CR>")

-- Tab motions
keymap("n", "<leader>tt", ":tabnew<CR>")
keymap("n", "<leader>l", ":tabnext<CR>")
keymap("n", "<leader>h", ":tabprevious<CR>")
keymap("n", "<leader>tc", ":tabclose<CR>", { silent = true, desc = "Close current tab" })

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

-- Move lines up and down
keymap("n", "J", "<cmd>m .+1<cr>==", { silent = true, desc = "Move line down" })
keymap("n", "K", "<cmd>m .-2<cr>==", { silent = true, desc = "Move line up" })
keymap("v", "J", ":m '>+1<cr>gv=gv", { silent = true, desc = "Move selection down" })
keymap("v", "K", ":m '<-2<cr>gv=gv", { silent = true, desc = "Move selection up" })

-- Jump list navigation (using default <C-o> instead of leader mapping)
