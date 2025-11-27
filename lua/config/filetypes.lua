-- JavaScript, JSX, TypeScript, and TSX filetype detection
vim.filetype.add({
  extension = {
    js = "javascript",
    jsx = "javascriptreact",
    ts = "typescript",
    tsx = "typescriptreact",
  },
  pattern = {
    [".*%.js"] = "javascript",
    [".*%.jsx"] = "javascriptreact",
    [".*%.ts"] = "typescript",
    [".*%.tsx"] = "typescriptreact",
  },
})