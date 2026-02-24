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
				return { timeout_ms = 500, lsp_format = lsp_format_opt }
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
		"NickvanDyke/opencode.nvim",
		keys = {
			{ "<leader>8t", "<cmd>lua require('opencode').toggle()<cr>", desc = "Toggle OpenCode" },
			{ "<leader>8a", "<cmd>lua require('opencode').ask()<cr>",    desc = "Ask OpenCode" },
		},
	},
}
