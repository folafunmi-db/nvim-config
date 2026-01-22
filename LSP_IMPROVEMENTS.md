# LSP Configuration Updates

## Recent Changes (January 22, 2026)

### 1. Fixed Deno/TypeScript Conflict
- **Issue**: Both `denols` and `ts_ls` were attaching to the same files, causing conflicts
- **Fix**: Added proper root directory detection:
  - `denols` only attaches when `deno.json` or `deno.jsonc` is present
  - `ts_ls` attaches to regular TypeScript/JavaScript projects with `tsconfig.json` or `package.json`
- **Impact**: No more duplicate LSP servers on the same buffer

### 2. Removed Debug Messages
- **Issue**: LSP attach messages ("LSP attached: cssmodules_ls...") were showing on every startup and when pressing `gi`
- **Fix**: Removed debug print statements from LspAttach autocmd
- **Impact**: Cleaner startup experience

### 3. Fixed RPC InvalidParams Error
- **Issue**: Error "invalid type: boolean `true`, expected struct DynamicRegistrationClientCapabilities"
- **Root Cause**: Biome LSP configuration was incorrectly modifying the capabilities structure
- **Fix**: Changed to disable capabilities using `server_capabilities` in `on_attach` callback
- **Impact**: No more LSP errors on startup

### 4. Fixed Hover Documentation Error
- **Issue**: Pressing `gk` caused error "'width' key must be a positive Integer"
- **Root Cause**: Custom hover implementation was calling `vim.lsp.util.open_floating_preview` with incorrect parameters
- **Fix**: Simplified to use built-in `vim.lsp.buf.hover()` for all hover keymaps (`gk`, `K`, `<leader>h`)
- **Impact**: Hover documentation now works reliably

### 5. Added Copilot Filter
- **Issue**: GitHub Copilot plugin was triggering LspAttach events
- **Fix**: Added early return in LspAttach callback to ignore Copilot
- **Impact**: No interference between Copilot and real LSP servers

### 6. Node.js Path Configuration
- **Added**: Automatic Node.js path detection for nvm users
- **Location**: `lua/config/lsp.lua:6-16`
- **Impact**: Ensures TypeScript language server can find Node.js from nvm
- **Details**: Automatically adds `~/.local/share/nvm/v22.22.0/bin` to PATH if not already present

## Current LSP Servers

The following LSP servers are configured and auto-attach based on file type:

### TypeScript/JavaScript Projects
- **`ts_ls`** - TypeScript/JavaScript language server (hover, completion, navigation)
  - Attaches when: `tsconfig.json`, `package.json`, or `jsconfig.json` is found
  - Does NOT attach in Deno projects

### Deno Projects  
- **`denols`** - Deno language server
  - Attaches when: `deno.json` or `deno.jsonc` is found
  - Does NOT attach in regular Node.js projects

### Formatting & Linting
- **`biome`** - Fast formatter and linter (formatting only, other capabilities disabled)
  - Auto-formats on save for JS/TS/JSON files
  - Keybindings:
    - `<leader>ff` - Format document
    - `<leader>fa` - Format and fix all issues

### UI/Styling
- **`tailwindcss`** - Tailwind CSS IntelliSense (hover currently disabled)
- **`cssmodules_ls`** - CSS Modules support (hover enabled)
- **`emmet_ls`** - Emmet abbreviation expansion
- **`htmx`** - HTMX attribute completion

### Other Languages
- **`gopls`** - Go
- **`rust_analyzer`** - Rust
- **`elixirls`** - Elixir
- **`html`** - HTML
- **`cssls`** - CSS/SCSS
- **`svelte`** - Svelte
- **`astro`** - Astro
- **`jsonls`** - JSON with schema support

## Keybindings

### Navigation
- `gd` - Go to definition
- `gi` - Go to implementation
- `gk` / `K` / `<leader>h` - Show hover documentation
- `gy` - Go to type definition
- `gr` - Show references
- `[g` / `]g` - Navigate diagnostics (previous/next)

### Code Actions
- `<C-i>` / `<leader>i` - Show code actions
- `<leader>rn` - Rename symbol
- `<C-k>` (insert mode) - Signature help

### Formatting
- `<leader>ff` - Format document (async)
- `<leader>fa` - Biome format and fix all
- `<leader>9` - Organize imports

### Troubleshooting
- `<leader>ls` - Show LSP status (which servers are attached)
- `<leader>li` - Show detailed LSP info (`:LspInfo`)
- `<leader>lr` - Restart LSP servers (`:LspRestart`)
- `<leader>ih` - Toggle inlay hints

## Known Issues & Expected Behavior

### When gi/gk Won't Work (Normal)
- **No implementation exists**: For interfaces, type aliases, or primitives
- **Already at implementation**: `gi` goes to implementation, you might already be there
- **Wrong file type**: LSP only works in supported languages
- **LSP still loading**: Wait 1-2 seconds after opening file

### Deno vs Node.js Detection
- Projects with **`deno.json`**: Only `denols` attaches
- Projects with **`tsconfig.json`** or **`package.json`**: Only `ts_ls` attaches  
- If both exist: `denols` takes precedence (Deno project)
- To force TypeScript: Remove `deno.json` or create `tsconfig.json`

## Configuration Files

All LSP configuration is in:
1. **`lua/plugins/lsp.lua`** - Plugin setup, Mason configuration, LSP loading events
2. **`lua/config/lsp.lua`** - Server configurations, keybindings, capabilities

## Troubleshooting

### Check LSP Status
```vim
:LspInfo          " Show all LSP clients
<leader>ls        " Show attached servers
```

### Common Issues

**"ts_ls and denols both attaching"**
- Check for both `deno.json` and `tsconfig.json` in your project
- Remove `deno.json` if this is a Node.js project
- Or remove `tsconfig.json` if this is a Deno project

**"No LSP attached"**
- Check file type: `:set filetype?`
- Verify language server is installed: `:Mason`
- Check LSP logs: `~/.local/state/nvim/lsp.log`

**"Hover shows nothing"**
- Some symbols don't have hover information (e.g., keywords)
- Try on a function name, variable, or type
- Check if LSP supports hover: `:LspInfo` → look for `hoverProvider`

**"Node.js path wrong"**
The configuration assumes: `~/.local/share/nvm/v22.22.0/bin`
Update in `lua/config/lsp.lua:7` if your nvm version differs:
```lua
local nvm_node_path = vim.fn.expand("~/.local/share/nvm/vYOUR_VERSION/bin")
```

## Performance Impact

- **Startup time**: No change (LSP lazy-loads on file open)
- **File opening**: ~20-50ms (LSP loads on `BufReadPre`)
- **Runtime**: No change
- **Memory**: ~5-10MB per LSP server (standard)

## Files Modified

1. `lua/plugins/lsp.lua` - Plugin configuration, Mason setup
2. `lua/config/lsp.lua` - Server configs, keymaps, Node.js path setup
3. `tsconfig.json` - Created to mark Neovim config as TypeScript project
4. `LSP_IMPROVEMENTS.md` - This documentation

---

**Last Updated**: January 22, 2026  
**Neovim Version**: 0.11.4 (using new `vim.lsp.config()` API)  
**Node.js Version**: v22.22.0 (via nvm)
