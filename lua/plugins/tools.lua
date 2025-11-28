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
      { "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Diff view open" },
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

  -- Copilot LSP
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      })
    end,
  },

  -- Copilot LSP for true LSP functionality
  {
    "copilotlsp-nvim/copilot-lsp",
    dependencies = { "zbirenbaum/copilot.lua" },
    event = "InsertEnter",
    config = function()
      -- This plugin provides the LSP server integration
      -- The actual LSP configuration is in lua/config/lsp.lua
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
        typescript= { "biome" },
        ts = { "biome" },
        jsx = { "biome" },
        javascriptreact = { "biome" },
        javascript= { "biome" },
        js = { "biome" },
        json = { "biome" },
        -- You can also use a fallback for other filetypes
        -- ["_"] = { "biome" },
      },
    },
  },



  -- OpenCode integration
  {
    "NickvanDyke/opencode.nvim",
    keys = {
      { "<leader>8t", "<cmd>lua require('opencode').toggle()<cr>", desc = "Toggle OpenCode" },
      { "<leader>8a", "<cmd>lua require('opencode').ask()<cr>", desc = "Ask OpenCode" },
    },
  },
}
