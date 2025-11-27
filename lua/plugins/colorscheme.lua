return {
  -- Colorscheme (loads early but not at startup)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-storm")
      
      -- Customize line number colors for better visibility
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#7aa2f7" })         -- Light blue for line numbers
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f7768e", bold = true }) -- Pink/red for current line number
    end,
  },
}
