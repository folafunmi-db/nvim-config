return {
  -- Treesitter (loads when opening files)
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "javascript", "typescript", "tsx",
          "html", "css", "json", "go", "rust",
          "elixir", "python", "kotlin",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })

      -- Treesitter context
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3,
      })
    end,
  },

  -- Auto-close tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
