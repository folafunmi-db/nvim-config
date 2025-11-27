-- JavaScript and JSX filetype detection
vim.filetype.add({
  extension = {
    jsx = "javascriptreact",
    js = "javascript",
  },
  pattern = {
    [".*%.js"] = "javascript",
    [".*%.jsx"] = "javascriptreact",
  },
})