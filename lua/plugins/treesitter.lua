return {
  -- Treesitter (loads when opening files)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })
      require("nvim-treesitter").install({
        "lua", "javascript", "typescript", "tsx",
        "html", "css", "json", "go", "rust",
        "elixir", "python", "kotlin",
      })

      -- Treesitter context
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3,
      })
    end,
  },

  -- Enhanced folding with treesitter
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPost",
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Use treesitter as fold provider
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return {'treesitter', 'indent'}
        end
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
