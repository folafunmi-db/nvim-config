-- LSP Configuration
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Basic servers that don't need special configuration
local basic_servers = {
  "gopls",
  "rust_analyzer", 
  "elixirls",
  "html",
  "cssls",
  "svelte",
  "astro",
}

-- Setup basic servers
for _, server in ipairs(basic_servers) do
  vim.lsp.enable(server)
  vim.lsp.config(server, {
    capabilities = capabilities,
  })
end

-- TypeScript/JavaScript configuration
vim.lsp.enable("ts_ls")
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
  commands = {
    OrganizeImports = {
      function()
        local params = {
          command = "_typescript.organizeImports",
          arguments = {vim.api.nvim_buf_get_name(0)},
          title = ""
        }
        vim.lsp.buf.execute_command(params)
      end,
      description = "Organize Imports"
    }
  }
})

-- ESLint configuration
vim.lsp.enable("eslint")
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

-- Biome configuration
vim.lsp.enable("biome")
vim.lsp.config("biome", {
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "javascriptreact", 
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "json",
    "jsonc",
  },
  on_attach = function(_, bufnr)
    -- Auto-fix on save using LSP format and code actions
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        -- Format document
        vim.lsp.buf.format({ 
          async = false,
          filter = function(c)
            return c.name == "biome"
          end
        })
        -- Apply code actions (auto-fix)
        vim.lsp.buf.code_action({
          filter = function(action)
            return action.kind == "source.fixAll.biome"
          end,
          apply = true,
        })
      end,
    })
  end,
})

-- Emmet configuration for JSX/TSX support
vim.lsp.enable("emmet_ls")
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
vim.lsp.enable("jsonls")
vim.lsp.config("jsonls", {
  capabilities = capabilities,
  settings = {
    json = {
      schemas = (function()
        local status_ok, schemastore = pcall(require, "schemastore")
        if status_ok then
          return schemastore.json.schemas()
        else
          return {}
        end
      end)(),
      validate = { enable = true },
    },
  },
})

-- Tailwind CSS configuration for React
vim.lsp.enable("tailwindcss")
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
    
    -- Navigation keymaps (matching your coc setup)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    
    -- Hover documentation (using gk instead of K to avoid conflicts)
    vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, opts)
    
    -- Code actions (matching your coc keymaps)
    vim.keymap.set("n", "<C-i>", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>i", vim.lsp.buf.code_action, opts)
    
    -- Diagnostic navigation (matching your coc [g and ]g)
    vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)
    
    -- Signature help (removed K mapping to avoid conflict with line movement)
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
    
    -- Rename symbol
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    
    -- Format document
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    
    -- Organize imports (for TypeScript/JavaScript files)
    vim.keymap.set("n", "<leader>oi", function()
      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)}
      })
    end, opts)
  end,
})