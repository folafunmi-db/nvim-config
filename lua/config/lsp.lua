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
