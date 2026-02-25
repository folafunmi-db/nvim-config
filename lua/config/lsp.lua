-- LSP Configuration
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Note: Node.js path is managed by fnm (Fast Node Manager)
-- fnm automatically handles Node.js availability via shell configuration

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
  -- Note: denols and ts_ls are configured separately to avoid conflicts
}

-- Setup basic servers
for _, server in ipairs(basic_servers) do
  vim.lsp.config(server, {
    capabilities = capabilities,
  })
  vim.lsp.enable(server)
end

-- TypeScript/JavaScript configuration
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  cmd = {
    "typescript-language-server",
    "--stdio",
  },
  root_markers = { "tsconfig.json", "package.json", "jsconfig.json" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  init_options = {
    hostInfo = "neovim",
    maxTsServerMemory = 4096,
    preferences = {
      includeCompletionsForModuleExports = true,
      includeCompletionsWithSnippetText = true,
      includeAutomaticOptionalChainCompletions = true,
      jsxAttributeCompletionStyle = "auto",
      allowTextChangesInNewFiles = true,
      disableSuggestions = false,
      quotePreference = "auto",
    },
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "none",
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "none",
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
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
vim.lsp.enable("ts_ls")

-- Deno configuration (only for Deno projects with deno.json)
vim.lsp.config("denols", {
  capabilities = capabilities,
  root_markers = { "deno.json", "deno.jsonc" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  init_options = {
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.nest.land"] = true,
          ["https://crux.land"] = true,
        },
      },
    },
  },
})
vim.lsp.enable("denols")

-- Biome configuration
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
  on_attach = function(client, bufnr)
    -- Disable all capabilities except formatting
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.completionProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.implementationProvider = false
    
    -- Auto-format on save (async for better performance)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        -- Format document asynchronously
        vim.lsp.buf.format({ 
          async = true,
          filter = function(c)
            return c.name == "biome"
          end
        })
      end,
    })
  end,
})
vim.lsp.enable("biome")

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
vim.lsp.enable("emmet_ls")

-- JSON configuration with schema support
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
vim.lsp.enable("jsonls")

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
vim.lsp.enable("tailwindcss")





-- Helper function: Check if any LSP client is attached to buffer
local function has_lsp_attached(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  return #clients > 0
end

-- Helper function: Get names of attached LSP clients
local function get_attached_lsp_names(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return names
end

-- Smart wrapper for LSP commands with user feedback
local function smart_lsp_call(lsp_method, method_name)
  return function()
    -- Get current buffer when the keymap is executed
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Check if LSP is attached
    if not has_lsp_attached(bufnr) then
      vim.notify(
        string.format("No LSP attached to this buffer. LSP commands like '%s' require an active language server.", method_name),
        vim.log.levels.WARN,
        { title = "LSP Not Ready" }
      )
      return
    end
    
    -- Check if the specific capability exists
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local has_capability = false
    
    for _, client in ipairs(clients) do
      -- Check method-specific capabilities
      if method_name == "implementation" and client.supports_method("textDocument/implementation") then
        has_capability = true
        break
      elseif method_name == "hover" and client.supports_method("textDocument/hover") then
        has_capability = true
        break
      elseif client.server_capabilities then
        has_capability = true  -- Assume capability for other methods
        break
      end
    end
    
    if not has_capability then
      local client_names = table.concat(get_attached_lsp_names(bufnr), ", ")
      vim.notify(
        string.format("LSP '%s' doesn't support '%s' for this file.", client_names, method_name),
        vim.log.levels.INFO,
        { title = "LSP Info" }
      )
      return
    end
    
    -- Execute the LSP method
    lsp_method()
  end
end

-- Keymaps (set after LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    -- Ignore Copilot (it's not a real LSP server)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and (client.name == "copilot" or client.name == "GitHub Copilot") then
      return
    end
    
    local opts = { buffer = ev.buf, silent = true }
    
    -- Navigation keymaps (matching your coc setup)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    
    -- Hover documentation (multiple bindings for convenience)
    vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
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
    
    -- LSP info and diagnostics keybindings for troubleshooting
    vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", 
      { buffer = ev.buf, silent = true, desc = "LSP Info" })
    vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", 
      { buffer = ev.buf, silent = true, desc = "LSP Restart" })
    vim.keymap.set("n", "<leader>ls", function()
      local clients = get_attached_lsp_names(ev.buf)
      if #clients > 0 then
        vim.notify(
          "Attached LSP servers: " .. table.concat(clients, ", "),
          vim.log.levels.INFO,
          { title = "LSP Status" }
        )
      else
        vim.notify("No LSP servers attached", vim.log.levels.WARN, { title = "LSP Status" })
      end
    end, { buffer = ev.buf, silent = true, desc = "Show LSP status" })
  end,
})