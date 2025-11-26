return {
  -- LSP Configuration (loads only when opening files)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/schemastore.nvim",
    },
    config = function()
      require("config.lsp")
    end,
  },

  -- Mason (LSP installer)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason LSP Config (auto-install LSP servers)
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",       -- TypeScript/JavaScript
          "html",        -- HTML
          "cssls",       -- CSS
          "tailwindcss", -- Tailwind CSS
          "eslint",      -- ESLint
          "biome",       -- Biome
          "jsonls",      -- JSON
          "emmet_ls",    -- Emmet
        },
        automatic_installation = true,
      })
    end,
  },

  -- JSON Schemas for jsonls
  {
    "b0o/schemastore.nvim",
    ft = "json", -- Load when opening JSON files
  },

  -- Completion (only when typing)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          -- Tab completion (matching coc.nvim behavior)
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          
          -- Scroll docs
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          
          -- Trigger completion (matching coc <C-Space>)
          ["<C-Space>"] = cmp.mapping.complete(),
          
          -- Abort completion
          ["<C-e>"] = cmp.mapping.abort(),
          
          -- Confirm selection (matching coc behavior)
          ["<CR>"] = cmp.mapping.confirm({ 
            behavior = cmp.ConfirmBehavior.Replace,
            select = false -- Only confirm explicitly selected items
          }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },
}
