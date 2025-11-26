-- Autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General group
local general = augroup("General", { clear = true })

-- Preserve scroll position when switching buffers
autocmd("BufLeave", {
  group = general,
  callback = function()
    if not vim.wo.diff then
      vim.b.winview = vim.fn.winsaveview()
    end
  end,
})

autocmd("BufEnter", {
  group = general,
  callback = function()
    if vim.b.winview and not vim.wo.diff then
      vim.fn.winrestview(vim.b.winview)
      vim.b.winview = nil
    end
  end,
})

-- Restore cursor position
autocmd("BufReadPost", {
  group = general,
  callback = function()
    local line = vim.fn.line("'\"'")
    if line > 0 and line <= vim.fn.line("$") and vim.bo.filetype ~= "gitcommit" then
      vim.cmd("normal! g`\"")
    end
  end,
})
