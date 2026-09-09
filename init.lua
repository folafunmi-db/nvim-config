-- Optimized Neovim Configuration
-- Fast startup with lazy loading

-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load in-repo overrides for archived/obsolete plugin bits so the fixes
-- survive plugin updates and work on any machine that clones this config.
local override_dir = vim.fn.stdpath("config") .. "/lua/override"
if vim.fn.isdirectory(override_dir) == 1 then
	package.path = override_dir .. "/?.lua;" .. override_dir .. "/?/init.lua;" .. package.path
	vim.opt.rtp:prepend(override_dir)

	-- Shadow nvim-treesitter's query_predicates with a patched copy that
	-- handles nvim 0.12's node-list match capture (hover crash fix).
	pcall(require, "nvim-treesitter.query_predicates")

	-- nvim-treesitter (archived) bundles a stale lua grammar + queries that
	-- trip nvim 0.12's strict query validation ("Invalid field name 'operator'").
	-- Drop them, let nvim core's lua queries win, and register a modern grammar
	-- (built from tree-sitter-grammars/tree-sitter-lua) shipped in this repo.
	local nvt = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter"
	if vim.fn.isdirectory(nvt .. "/runtime/queries/lua") == 1 then
		vim.fn.delete(nvt .. "/runtime/queries/lua", "rf")
	end
	if vim.fn.filereadable(nvt .. "/parser/lua.so") == 1 then
		vim.fn.delete(nvt .. "/parser/lua.so")
	end

	local modern_lua = override_dir .. "/parser/lua.so"
	if vim.fn.filereadable(modern_lua) == 1 then
		vim.treesitter.language.add("lua", modern_lua)
	end
end

-- Load core options first (no plugins needed)
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.filetypes")

-- Setup lazy.nvim with optimized settings
require("lazy").setup("plugins", {
	defaults = {
		lazy = true, -- Make all plugins lazy by default
	},
	performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
