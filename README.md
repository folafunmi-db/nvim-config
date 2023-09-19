## Nvim config

For the sake of sanity, I really do not want to rewrite this from scratch.

Steps:

- Install with brew: `brew install neovim`
- Clone this into ~/.config/nvim
- Install vim-plug from github
- Install all plugins with `:PlugInstall`
- Go into `/plugged/coc.nvim/` and run `yarn` or `npm i`
- Install patched font from your icursive github repo or nerd fonts site
- Install tree-sitter lang servers with `TSInstall`
- Install Coc plugins with `CocInstall`
- Install Lsp plugins with `LspInstall`

Note: You'd need to install this ripgrep, gnu-sed, fzf, and the language servers for this to work.

TODO

- Rewrite this in lua (later, this works for now)
