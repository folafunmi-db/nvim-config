-- LSP Configuration
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Optimize LSP performance for large JSX files
local function optimize_lsp_for_jsx()
  -- Reduce diagnostic update frequency
  vim.lsp.set_log_level("WARN")
  
  -- Configure diagnostic options for better performance
  vim.diagnostic.config({
    update_in_insert = false,  -- Don't update diagnostics in insert mode
    severity_sort = true,
    virtual_text = {
      spacing = 4,
      source = "if_many",
    },
  })
end

optimize_lsp_for_jsx()

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
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/typescript-language-server", "--stdio" },
  capabilities = capabilities,
  priority = 10,  -- High priority for go-to-definition
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
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
      -- Disable inlay hints for better performance in large JSX files
      inlayHints = {
        includeInlayParameterNameHints = "none",
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
      },
      -- Optimize for large codebases
      preferences = {
        includeCompletionsForModuleExports = false,
        includeCompletionsWithSnippetText = false,
      },
    },
    javascript = {
      -- Disable inlay hints for better performance in large JSX files
      inlayHints = {
        includeInlayParameterNameHints = "none",
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
      },
      preferences = {
        includeCompletionsForModuleExports = false,
        includeCompletionsWithSnippetText = false,
      },
    },
  },
  commands = {
    OrganizeImports = {
      function()
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })
      end,
      description = "Organize Imports"
    }
  }
})

-- Biome configuration
vim.lsp.enable("biome")
vim.lsp.config("biome", {
  capabilities = capabilities,
  priority = 5,  -- Lower priority (formatting only)
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
    -- Auto-format on save (async for better performance)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        -- Format document asynchronously
        vim.lsp.buf.format({ 
          async = true,  -- Changed to async for better performance
          filter = function(c)
            return c.name == "biome"
          end
        })
        -- Skip auto-fix code actions on save to improve performance
        -- Use <leader>bf for manual format + fix when needed
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
    vim.keymap.set("n", "<leader>ff", function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = ev.buf, silent = true, desc = "Format document" })
    
    -- Biome-specific: Format and fix all issues
    vim.keymap.set("n", "<leader>fa", function()
      -- First format with Biome
      vim.lsp.buf.format({
        async = false,
        filter = function(client)
          return client.name == "biome"
        end
      })
      -- Then apply code actions for fixes
      vim.lsp.buf.code_action({
        filter = function(action)
          return action.kind == "source.fixAll.biome"
        end,
        apply = true,
      })
    end, { buffer = ev.buf, silent = true, desc = "Biome format and fix all" })
    
    -- Organize imports (for TypeScript/JavaScript files)
    vim.keymap.set("n", "<leader>9", function()
      -- Try code action first (works for both Biome and TypeScript)
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
    end, { buffer = ev.buf, silent = true, desc = "Organize imports" })
    
    -- Toggle inlay hints for performance (disabled by default now)
    vim.keymap.set("n", "<leader>ih", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { buffer = ev.buf, silent = true, desc = "Toggle inlay hints" })
  end,
})