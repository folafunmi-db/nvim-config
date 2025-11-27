-- JavaScript, JSX, TypeScript, and TSX filetype detection
vim.filetype.add({
  extension = {
    js = "javascript",
    jsx = "javascriptreact", 
    ts = "typescript",
    tsx = "typescriptreact",
  },
  filename = {
    [".eslintrc.js"] = "javascript",
    [".eslintrc.cjs"] = "javascript",
  },
  pattern = {
    [".*%.js$"] = "javascript",
    [".*%.jsx$"] = "javascriptreact",
    [".*%.ts$"] = "typescript", 
    [".*%.tsx$"] = "typescriptreact",
    -- Additional patterns for TypeScript files
    [".*%.d%.ts$"] = "typescript",
    [".*%.mts$"] = "typescript",
    [".*%.cts$"] = "typescript",
  },
})

-- Force filetype detection for TypeScript files (backup method)
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.ts", "*.tsx"},
  callback = function()
    local filename = vim.fn.expand("%:t")
    if filename:match("%.tsx$") then
      vim.bo.filetype = "typescriptreact"
    elseif filename:match("%.ts$") then
      vim.bo.filetype = "typescript"
    end
  end,
})