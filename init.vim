:set ic
:set noscs
:set relativenumber
:set number
:set autoindent
:set smartindent
:set tabstop=2
:set shiftwidth=2
:set smarttab
:set scrolloff=999
:set softtabstop=2
:set mouse=a
:set encoding=UTF-8
:set nowrap
:set autowriteall
:set foldmethod=indent
:set foldnestmax=10
:set nofoldenable
:set foldlevel=99
:set background=dark
:set colorcolumn=100
:set clipboard+=unnamedplus
:set updatetime=300

" use globalstatus line
" :set laststatus=3
" make the of the window separator same as bg so the line looks thin
" :highlight WinSeparator guibg=None

" To run a profiling
" :profile start profile.log
" :profile func *
" :profile file *
" " At this point do slow actions
" :profile pause
" :noautocmd qall!

call plug#begin('~/.config/nvim/plugged')

" Plug 'https://gitlab.com/schrieveslaach/sonarlint.nvim'
Plug 'wuelnerdotexe/vim-astro'
Plug 'elixir-editors/vim-elixir'
" Plug 'Rigellute/shades-of-purple.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'https://github.com/windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'akinsho/toggleterm.nvim', {'tag' : 'v2.*'}
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-pack/nvim-spectre'
Plug 'mfussenegger/nvim-dap'
" Plug 'ThePrimeagen/harpoon'
Plug 'unkiwii/vim-nerdtree-sync'
Plug 'https://github.com/simeji/winresizer'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'https://github.com/JoosepAlviste/nvim-ts-context-commentstring'
Plug 'https://github.com/preservim/nerdtree' " NerdTree
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'https://github.com/tc50cal/vim-terminal' " Vim Terminal
Plug 'https://github.com/neoclide/coc.nvim'  " Auto Completion
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'jparise/vim-graphql'
Plug 'dyng/ctrlsf.vim'
Plug 'wakatime/vim-wakatime'
Plug 'matze/vim-move'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'weilbith/nvim-code-action-menu'
Plug 'kosayoda/nvim-lightbulb'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'
Plug 'puremourning/vimspector'
Plug 'christoomey/vim-tmux-navigator'

" auto-completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

call plug#end()

" use \\ as leader
let mapleader="\\"

" For vim multi to select all occurences in a file
let g:VM_maps = {}
let g:VM_maps["Select All"] = '<C-S-n>'

if (has("termguicolors"))
  set termguicolors
endif

if (has("nvim"))
	let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

" Fix italics in Vim
if !has('nvim')
  let &t_ZH = "\e[3m"
  let &t_ZR = "\e[23m"
endif

" shades of purple theme config - not in use now though
" syntax enable
" colorscheme shades_of_purple
" let g:shades_of_purple_airline = 1
" let g:airline_theme='shades_of_purple'

" Enable syntax highlighting
syntax on

" tokyonight theme config
colorscheme tokyonight-storm
" colorscheme toast

" disable bg transparent
" let g:transparent_enabled = v:false

" vim-astro config
let g:astro_typescript = 'enable'
let g:astro_stylus = 'enable'

let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

let g:nerdtree_sync_cursorline = 1
let g:NERDTreeHighlightCursorline = 1

" show git status with symbols
let g:NERDTreeGitStatusWithFlags = 1

" show hidden files
let NERDTreeShowHidden=1

" enable line numbers
let NERDTreeShowLineNumbers=1

" for vim-svelte to enable preprocessors
 let g:svelte_preprocessor_tags = [
   \ { 'name': 'postcss', 'tag': 'style', 'as': 'scss' },
	 \ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' }
  \ ]

" NOTE: check update this
let g:svelte_preprocessors = ['ts', 'postcss', 'scss']

let g:LanguageClient_serverCommands = {
\ 'rust': ['rust-analyzer'],
\ 'go': ['gopls']
\ }

" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" vim-prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

nmap <C-b> :NERDTreeToggle<CR>
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle

" Preserve scroll position when switching between buffers
au BufLeave * if !&diff | let b:winview = winsaveview() | endif
au BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | unlet! b:winview | endif

" Prevent Tab on NERDTree (breaks everything otherwise)
autocmd FileType nerdtree noremap <buffer> <Tab> <nop>

" nvim code actions
nnoremap <silent> <C-i> <cmd>:CodeActionMenu<CR>

" Restore cursor position
au BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") && &filetype != "gitcommit" |
    \ execute("normal `\"") |
  \ endif

" Automatically close vim if only NERDTree left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Open NERDTree when vim opens
" au VimEnter *  NERDTree

" Focus on opened view after starting (instead of NERDTree)
"autocmd VimEnter * call SyncTree()
au VimEnter * :wincmd w

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
" autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    " \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Open NERDTree on the right
let g:NERDTreeWinPos = "right"

" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ ]

"Add missing go imports on save
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=0 OR :silent call CocAction('runCommand', 'editor.action.organizeImport')

set hidden 
set nobackup
set nowritebackup
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <C-space> coc#refresh()
  " inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap keys for switching panes
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" Split panes
nnoremap <leader>s :split <CR>
nnoremap <leader>v :vsplit <CR>

" Tab motions
" nnoremap <leader>t :tabnew <CR>
" nnoremap <leader>l :tabnext <CR>
" nnoremap <leader>h :tabprevious <CR>

" For case insensistive search
:nnoremap <silent> <CR> :nohlsearch<CR><CR>

" For moving lines up and down
let g:move_key_modifier = 'S'
let g:move_key_modifier_visualmode = 'S'

" quit visual mutlti
nnoremap <silent> <C-c> <cmd>:VMClear<CR>

" esc in insert & visual mode
:inoremap <C-[> <Esc>
:inoremap <C-c> <Esc>
:vnoremap <C-[> <Esc>
:vnoremap <C-c> <Esc>
" :set timeoutlen=500

" esc in command mode
:cnoremap <C-c> <C-C>
:cnoremap <C-[> <C-C>

" remap c-z to undo
nnoremap <C-Z> u
nnoremap <C-s-z> u
		
" Use gk to show documentation in preview window
nnoremap <silent> gk :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
	endif
endfunction

" Telescope config vim
nnoremap <c-p> <cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>
nnoremap <leader>p <cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>
nnoremap <c-o> <cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>
nnoremap <c-m> <cmd>lua require('telescope.builtin').buffers()<cr>

" make the line numbers standout
" :highlight LineNr term=bold cterm=NONE ctermfg=White ctermbg=NONE gui=NONE guifg=White guibg=NONE

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

	require('lspconfig').elixirls.setup {
		cmd = { "elixir-ls" },
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = { "elixir", "eelixir", "heex", "surface", "exs", "lock"}
	}
EOF

lua << EOF
	require'lspconfig'.pyright.setup{}

	vim.filetype.add({
		extension = {
			mdx = 'markdown'
		}
	})

	require("rust-tools").setup({
		server = {
			on_attach = function(_, bufnr)
				-- Hover actions
				 vim.keymap.set("n", "<leader>i", rt.hover_actions.hover_actions, { buffer = bufnr })
				-- Code action groups
				 vim.keymap.set("n", "<c-i>", rt.code_action_group.code_action_group, { buffer = bufnr })
			end,
		},
	})

	-- nvim lightbulb config
	require('nvim-lightbulb').setup({autocmd = {enabled = true}})

	util = require "lspconfig/util"

	require'lspconfig'.tailwindcss.setup{}

	-- go lspconfig
	require'lspconfig'.gopls.setup {
		cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
	}
	-- astro lspconfig
	require'lspconfig'.astro.setup{}

	-- ts lspconfig
	 require('lspconfig')['tsserver'].setup{
		on_attach = on_attach,
		flags = lsp_flags,
	}

	local on_attach = function(client)
    require'completion'.on_attach(client)
	end

	 -- rust_analyzer lspconfig
	 require('lspconfig')['rust_analyzer'].setup{
		on_attach = on_attach,
		flags = lsp_flags,
		cmd = {
			"rustup", "run", "stable", "rust-analyzer",
				},
		settings = {
				["rust-analyzer"] = {
						imports = {
								granularity = {
										group = "module",
								},
								prefix = "self",
						},
						cargo = {
								buildScripts = {
										enable = true,
								},
						},
						procMacro = {
								enable = true
						},
				}
		}
	 }

		-- nvim-transparent config
			-- require("transparent").setup({
			-- extra_groups = { -- table/string: additional groups that should be cleared
			-- 	-- In particular, when you set it to 'all', that means all available groups

			-- 	-- example of akinsho/nvim-bufferline.lua
			-- 	"BufferLineTabClose",
			-- 	"BufferlineBufferSelected",
			-- 	"BufferLineFill",
			-- 	"BufferLineBackground",
			-- 	"BufferLineSeparator",
			-- 	"BufferLineIndicatorSelected",
			-- },
		-- })

	local lga_actions = require("telescope-live-grep-args.actions")

	-- telescope config
	require('telescope').setup{
		extensions = {
			fzf = {
				fuzzy = true,                    -- false will only do exact matching
				override_generic_sorter = true,  -- override the generic sorter
				override_file_sorter = true,     -- override the file sorter
				case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
																				 -- the default case_mode is "smart_case"
			},
			live_grep_args = {
				auto_quoting = true, -- enable/disable auto-quoting
				mappings = { -- extend mappings
					i = {
						["<C-k>"] = lga_actions.quote_prompt(),
						["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					},
				},
				-- ... also accepts theme settings, for example:
				-- theme = "dropdown", -- use dropdown theme
				-- theme = { }, -- use own theme spec
				-- layout_config = { mirror=true }, -- mirror preview pane
			}
		}
	}

	require('telescope').load_extension('fzf')

	-- webdev icons config
	require'nvim-web-devicons'.setup {
		 override = {
			 zsh = {
				 icon = "",
				 color = "#428850",
				 cterm_color = "65",
				 name = "Zsh"
			 } 
		 },
		 default = true,
	}

	-- bufferline config
	require("bufferline").setup{
		options = {
			mode = "tabs", 
			diagnostics = "coc",
			diagnostics_update_in_insert = false,
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local s = " "
				for e, n in pairs(diagnostics_dict) do
					local sym = e == "error" and " "
						or (e == "warning" and " " or "" )
					s = s .. n .. sym
				end
				return s
			end
		}	
	}

	-- preconfig for indent blankline
	vim.opt.list = true
	-- vim.opt.listchars:append "eol:↴"
  vim.opt.listchars:append "space:⋅"

	-- colorizer config
	require'colorizer'.setup()

	-- indentation config
	require("indent_blankline").setup {
		space_char_blankline = " ",
    show_current_context = true,
		show_end_of_line = true,
    show_current_context_start = true,
	}

	-- tree sitter plugin
	require'nvim-treesitter.configs'.setup({
		autotag = {
			enable = true,
    },
		indent = {
    	enable = true
  	},
  	highlight = {
    	enable = true,
    	additional_vim_regex_highlighting = false,
  	},
		context_commentstring = {
			enable = true,
		}
	})
EOF

lua << EOF
	local ToggleTerm = require("toggleterm")

	ToggleTerm.setup({
	  open_mapping = [[<leader>e]],
	  direction="float"
	})

	local Terminal  = require('toggleterm.terminal').Terminal

  local lazygit = Terminal:new({ cmd = "lazygit", dir = "git_dir", hidden = true })

	function _LAZYGIT_TOGGLE()
		lazygit:toggle()
	end

	vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", {noremap = true, silent = true})

	function _G.set_terminal_keymaps()
	  local opts = {buffer = 0}
	  vim.keymap.set('t', '<esc>', [[<C-.><C-n>]], opts)
	  vim.keymap.set('t', 'jk', [[<C-.><C-n>]], opts)
	  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
	  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
	  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
	  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
	end

	-- if you only want these mappings for toggle term use term://*toggleterm#* instead
	vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
EOF

augroup mygroup
	autocmd FileType scss setl iskeyword+=@-@

  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" vimspector key bindings
nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>de :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dk <Plug>VimspectorRestart
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver

