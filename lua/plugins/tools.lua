return {
	-- Git integration
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep" },
	},

	-- Git diff viewer
	{
		"sindrets/diffview.nvim",
		keys = {
			{ "<leader>dv", "<cmd>DiffviewOpen<cr>",  desc = "Diff view open" },
			{ "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diff view close" },
		},
	},

	-- Commenting
	{
		"tpope/vim-commentary",
		keys = { "gc", "gcc" },
	},

	-- Surround
	{
		"tpope/vim-surround",
		keys = { "ys", "cs", "ds" },
	},

	-- Multi-cursor
	{
		"mg979/vim-visual-multi",
		keys = { "<C-n>", "<C-S-n>" },
		init = function()
			vim.g.VM_maps = { ["Select All"] = "<C-S-n>" }
		end,
	},

	-- Window management
	{
		"szw/vim-maximizer",
		keys = {
			{ "<leader>ww", "<cmd>MaximizerToggle<cr>", desc = "Maximize window" },
		},
	},

	-- Tmux integration for seamless navigation
	{
		"christoomey/vim-tmux-navigator",
		lazy = false, -- Load immediately to ensure tmux navigation works
		config = function()
			-- This plugin unconditionally maps <C-h>/<C-j>/<C-k>/<C-l> to tmux navigation.
			-- Re-map <C-j>/<C-k> for line movement (defined in keymaps.lua) and
			-- remove <C-h>/<C-l> entirely.
			vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
			vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
			vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
			vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
			vim.keymap.del("n", "<C-h>")
			vim.keymap.del("n", "<C-l>")
			vim.keymap.del("t", "<C-h>")
			vim.keymap.del("t", "<C-l>")
		end,
	},

	-- Copilot LSP for true LSP functionality
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			-- Disable default tab mapping to avoid conflicts with nvim-cmp
			-- Tab handling is managed by nvim-cmp configuration
			vim.g.copilot_no_tab_map = true
			-- Keep Ctrl+J as backup for accepting suggestions
			vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
		end,
	},

	-- Conform formatter
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			format_on_save = function(bufnr)
				-- disable LSP format to prevent conflicts if you want Biome to be the sole formatter
				local lsp_format_opt = "never"
				return { timeout_ms = 2000, lsp_format = lsp_format_opt }
			end,
			formatters_by_ft = {
				-- Set Biome as the formatter for tsx, ts, jsx, js, etc.
				tsx = { "biome" },
				typescriptreact = { "biome" },
				typescript = { "biome" },
				ts = { "biome" },
				jsx = { "biome" },
				javascriptreact = { "biome" },
				javascript = { "biome" },
				js = { "biome" },
				json = { "biome" },
				python = { "isort", "black" },
				-- You can also use a fallback for other filetypes
				-- ["_"] = { "biome" },
			},
		},
	},

	-- Search and replace
	{
		"nvim-pack/nvim-spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>sr", function() require("spectre").open() end, desc = "Search & Replace (Spectre)" },
			{ "<leader>sw", function() require("spectre").open_visual({select_word=true}) end, desc = "Search current word" },
			{ "<leader>sf", function() require("spectre").open_file_search() end, desc = "Search in current file" },
		},
	},

	-- OpenCode integration
	{
		"sudo-tee/opencode.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("opencode").setup({
				keymap_prefix = "<leader>8",
				ui = {
					window_width = 0.50,
				}
			})
		end,
	},
}
