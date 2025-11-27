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
        highlight = { 
          enable = true,
          -- Disable for very large files to improve performance
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        indent = { 
          enable = true,
          -- Disable indent for JSX files as it can be slow
          disable = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        },
        fold = { enable = true },
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
