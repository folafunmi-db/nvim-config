return {
  -- File explorer (loads on keypress)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    keys = {
      { "<C-b>", "<cmd>Neotree filesystem toggle reveal float<cr>", desc = "Neo-tree" },
      { "<leader>j", "<cmd>Neotree filesystem toggle reveal float<cr>", desc = "Neo-tree" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = { hijack_netrw_behavior = "disabled" },
        window = {
          position = "float",
          mappings = {
            ["<cr>"] = "open",
            ["o"] = "open",
            ["x"] = "close_node",
          },
        },
      })
    end,
  },

  -- Terminal (loads on keypress)
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<leader>k", desc = "Toggle terminal" },
      { "<leader>g", desc = "Lazygit" },
    },
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<leader>k]],
        direction = "float",
        insert_mappings = false,
        terminal_mappings = false,
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
      vim.keymap.set("n", "<leader>g", function() lazygit:toggle() end)
    end,
  },

  -- Bufferline (deferred)
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "tabs",
        },
      })
    end,
  },

  -- Statusline (loads immediately for better UX)
  {
    "vim-airline/vim-airline",
    lazy = false,
  },

  -- Icons (dependency for other plugins)
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
}
