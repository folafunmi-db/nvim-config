:set ic
:set noscs
:set relativenumber
:set number
:set autoindent
:set smartindent
:set tabstop=2
:set shiftwidth=2
:set smarttab
:set scrolloff=10
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

Plug 'wuelnerdotexe/vim-astro'
Plug 'https://github.com/xiyaowong/nvim-transparent'
Plug 'Rigellute/shades-of-purple.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'junnplus/lsp-setup.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'windwp/nvim-autopairs'
Plug 'https://github.com/windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'akinsho/toggleterm.nvim', {'tag' : 'v2.*'}
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/plenary.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'psliwka/vim-smoothie'
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
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'jparise/vim-graphql'
Plug 'dyng/ctrlsf.vim'
Plug 'wakatime/vim-wakatime'
Plug 'matze/vim-move'

call plug#end()

if (has("termguicolors"))
  set termguicolors
endif

if (has("nvim"))
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" Fix italics in Vim
if !has('nvim')
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
endif

" material theme config
" let g:material_theme_style = "default-community"
" let g:material_terminal_italics = 1
" let g:airline_theme = 'material'
" colorscheme material

" shades of purple theme config
" syntax enable
" colorscheme shades_of_purple
" let g:shades_of_purple_airline = 1
" let g:airline_theme='shades_of_purple'

" tokyonight theme config
colorscheme tokyonight-storm

" disable bg transparent
" let g:transparent_enabled = v:false

" vim-astro config
let g:astro_typescript = 'enable'
let g:astro_stylus = 'enable'

let g:rustfmt_autosave = 1

let g:nerdtree_sync_cursorline = 1
let g:NERDTreeHighlightCursorline = 1

" show git status with symbols
let g:NERDTreeGitStatusWithFlags = 1

" show hidden files
let NERDTreeShowHidden=1

" enable line numbers
let NERDTreeShowLineNumbers=1

" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" vim-prettier
"let g:prettier#quickfix_enabled = 0
"let g:prettier#quickfix_auto_focus = 0
" prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile

nmap <C-b> :NERDTreeToggle<CR>
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle

" Preserve scroll position when switching between buffers
au BufLeave * if !&diff | let b:winview = winsaveview() | endif
au BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | unlet! b:winview | endif

" Prevent Tab on NERDTree (breaks everything otherwise)
autocmd FileType nerdtree noremap <buffer> <Tab> <nop>


" Restore cursor position
au BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") && &filetype != "gitcommit" |
    \ execute("normal `\"") |
  \ endif

" Automatically close vim if only NERDTree left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Open NERDTree when vim opens
au VimEnter *  NERDTree

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

"autocmd FileType go nmap gtj :CocCommand go.tags.add json<cr>
"autocmd FileType go nmap gty :CocCommand go.tags.add yaml<cr>
"autocmd FileType go nmap gtx :CocCommand go.tags.clear<cr>

set hidden 
set nobackup
set nowritebackup
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

:set completeopt-=preview " For No Previews

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <cr> "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [gc<Plug>(coc-diagnostic-prev)
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

" for case insensistive search
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
" Note: In command mode mappings to esc run the command for some odd
" historical vi compatibility reason. We use the alternate method of
" existing which is Ctrl-C

" :inoremap <S-CR> <Esc>
" :nnoremap <S-CR> <Esc>
" :vnoremap <S-CR> <Esc>
" :cnoremap <S-CR> <C-C>

" For inner search
nmap <C-s-f> <Plug>CtrlSFPrompt
vmap <C-s-f> <Plug>CtrlSFVwordPath

" remap c-z to undo
nnoremap <C-Z> u
nnoremap <C-s-z> u
			
" Use K to show documentation in preview window
nnoremap <silent> gk :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
	endif
endfunction

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Keybinding for ThePrimeagen's harpoon
nnoremap <c-a> :lua require("harpoon.mark").add_file()<CR>
nnoremap <c-m> :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <c-s-m> :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <c-s-o> :lua require("harpoon.ui").nav_next()<CR>
nnoremap <c-s-i> :lua require("harpoon.ui").nav_prev()<CR>

" Toogle term config for lazygit 
" nnoremap <c-g> :lua _LAZYGIT_TOGGLE()<CR>

" Telescope config vim
nnoremap <c-p> <cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>
nnoremap <c-o> <cmd>lua require('telescope.builtin').live_grep({ disable_coordinates=true })<cr>

" make the line numbers white
:highlight LineNr term=bold cterm=NONE ctermfg=White ctermbg=NONE gui=NONE guifg=White guibg=NONE

lua << EOF
	-- astro lspconfig
		require'lspconfig'.astro.setup{}
  -- nvim-transparent config
		require("transparent").setup({
		enable = true, -- boolean: enable transparent
		extra_groups = { -- table/string: additional groups that should be cleared
			-- In particular, when you set it to 'all', that means all available groups

			-- example of akinsho/nvim-bufferline.lua
			"BufferLineTabClose",
			"BufferlineBufferSelected",
			"BufferLineFill",
			"BufferLineBackground",
			"BufferLineSeparator",
			"BufferLineIndicatorSelected",
		},
		exclude = {}, -- table: groups you don't want to clear
	})

	-- telescope config
	require('telescope').setup{
		defaults = {
			vimgrep_arguments = {
				'rg',
				'--files',
				'--hidden',
				'--color=never',
				'--no-heading',
				'--with-filename',
				'--line-number',
				'--column',
				'--smart-case',
				'-u', -- thats the new thing
				'!.git',
			},
		},
		extensions = {
			fzf = {
				fuzzy = true,                    -- false will only do exact matching
				override_generic_sorter = true,  -- override the generic sorter
				override_file_sorter = true,     -- override the file sorter
				case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
			},
			live_grep_args = {
				auto_quoting = true, -- enable/disable auto-quoting
				mappings = {
					i = {
						["<C-k>"] = actions.quote_prompt(),
						["<C-l>g"] = actions.quote_prompt({ postfix = ' --iglob ' }),
						["<C-l>t"] = actions.quote_prompt({ postfix = ' -t' }),
					}
				}
			}
		}
	}

	require('telescope').load_extension('fzf')
	require("telescope").load_extension("live_grep_args")

	-- webdev icons config
	require'nvim-web-devicons'.setup {
		 override = {
			 zsh = {
				 icon = "",
				 color = "#428850",
				 cterm_color = "65",
				 name = "Zsh"
			 } 
		 };
		 default = true;
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
	vim.opt.listchars:append "eol:↴"
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

	-- autopairs config
	local npairs = require("nvim-autopairs")

	npairs.setup({
			enable_check_bracket_line = false,
			check_ts = true,
			-- ts_config = {
					-- lua = {'string'},-- it will not add a pair on that treesitter node
					-- javascript = {'template_string'},
					-- java = false,-- don't check treesitter on java
			-- }
	})

	-- local ts_conds = require('nvim-autopairs.ts-conds')
EOF

lua << EOF
	-- tree sitter plugin
	require'nvim-treesitter.configs'.setup {
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
			enable = true
		}
	}
EOF

lua << EOF
	local ToggleTerm = require("toggleterm")

	ToggleTerm.setup({
	  open_mapping = [[<c-\>]],
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
	  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
	  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
	  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
	  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
	  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
	  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
	end

	-- if you only want these mappings for toggle term use term://*toggleterm#* instead
	vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

EOF

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

