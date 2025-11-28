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
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Icons (dependency for other plugins)
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Indent lines and paragraph visualization
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = true,
        },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
      })
    end,
  },

  -- Error lens and diagnostics
  {
    "folke/trouble.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
    config = function()
      require("trouble").setup({
        modes = {
          preview_float = {
            mode = "diagnostics",
            preview = {
              type = "float",
              relative = "editor",
              border = "rounded",
              title = "Preview",
              title_pos = "center",
              position = { 0, -2 },
              size = { width = 0.3, height = 0.3 },
              zindex = 200,
            },
          },
        },
      })
    end,
  },

  -- Inline diagnostics (error lens)
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("lsp_lines").setup()
      
      -- Disable virtual_text since lsp_lines provides better inline diagnostics
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = true,
      })
      
      -- Toggle function for lsp_lines
      vim.keymap.set("", "<Leader>l", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
        else
          vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
        end
      end, { desc = "Toggle LSP Lines" })
    end,
  },
}
