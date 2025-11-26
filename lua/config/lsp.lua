-- LSP Configuration
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Language servers with lazy setup
local servers = {
  "ts_ls",
  "gopls",
  "rust_analyzer",
  "elixirls",
  "html",
  "cssls",
  "svelte",
  "tailwindcss",
  "astro",
  "eslint",
  "jsonls",
  "emmet_ls",
}

-- Basic server configurations
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    capabilities = capabilities,
  })
end

-- Special configurations for gopls
vim.lsp.config("gopls", {
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
})

-- TypeScript/JavaScript configuration
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
})

-- ESLint configuration
vim.lsp.config("eslint", {
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  settings = {
    workingDirectories = { mode = "auto" },
  },
  on_attach = function(_, bufnr)
    -- Auto-fix on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

-- Emmet configuration for JSX/TSX support
vim.lsp.config("emmet_ls", {
  capabilities = capabilities,
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
})

-- JSON configuration with schema support
vim.lsp.config("jsonls", {
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").schemas(),
      validate = { enable = true },
    },
  },
})

-- Tailwind CSS configuration for React
vim.lsp.config("tailwindcss", {
  capabilities = capabilities,
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
})

-- Keymaps (set after LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>i", vim.lsp.buf.code_action, opts)
  end,
})
