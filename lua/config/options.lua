-- Core Neovim options
-- These load immediately without plugins

local opt = vim.opt

-- Search settings
opt.ignorecase = true
opt.smartcase = true

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.autoindent = true
opt.smartindent = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smarttab = true

-- UI
opt.scrolloff = 999
opt.mouse = "a"
opt.encoding = "UTF-8"
opt.wrap = false
opt.autowriteall = true
opt.background = "dark"
opt.colorcolumn = "100"
opt.clipboard:append("unnamedplus")
opt.updatetime = 300
opt.termguicolors = true

-- Backup and undo
opt.hidden = true
opt.backup = false
opt.writebackup = false
opt.shortmess:append("c")
opt.signcolumn = "yes"

-- Folding
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Performance
opt.laststatus = 3
opt.lazyredraw = true
