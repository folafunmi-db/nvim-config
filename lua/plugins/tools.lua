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

  -- Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
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
