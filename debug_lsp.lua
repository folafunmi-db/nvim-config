-- Quick LSP diagnostics and fixes
-- Run this script with: nvim -l debug_lsp.lua

print("=== LSP Debug Information ===")

-- Test 1: Check Neovim version
local version = vim.version()
print(string.format("Neovim version: %d.%d.%d", version.major, version.minor, version.patch))

if version.major == 0 and version.minor < 11 then
	print("⚠️  Warning: You're using new LSP config format on Neovim < 0.11")
	print("   Consider upgrading Neovim or switching to lspconfig")
end

-- Test 2: Check if file is detected as JSX
vim.cmd("edit test.jsx")
local ft = vim.bo.filetype
print("File type detected: " .. ft)

if ft ~= "javascriptreact" then
	print("❌ File not detected as JSX. Setting filetype...")
	vim.bo.filetype = "javascriptreact"
end

-- Test 3: Wait for LSP to attach
print("Waiting for LSP to attach...")
vim.wait(3000, function()
	return #vim.lsp.get_clients({ bufnr = 0 }) > 0
end)

local clients = vim.lsp.get_clients({ bufnr = 0 })
print(string.format("Attached clients: %d", #clients))

for _, client in ipairs(clients) do
	print(string.format("  - %s (id: %d)", client.name, client.id))

	-- Check code action capability
	local supports_code_action = client.supports_method("textDocument/codeAction")
	print(string.format("    Supports code actions: %s", supports_code_action))
end

-- Test 4: Test code actions at current position
if #clients > 0 then
	print("\nTesting code actions...")

	-- Move to a specific line to test
	vim.api.nvim_win_set_cursor(0, { 10, 0 })

	local params = vim.lsp.util.make_range_params()
	params.context = {
		diagnostics = vim.diagnostic.get(0, { lnum = 9 }),
		only = nil -- Accept all code action kinds
	}

	local results = {}
	local completed = 0
	local total_clients = #clients

	for _, client in ipairs(clients) do
		if client.supports_method("textDocument/codeAction") then
			client.request("textDocument/codeAction", params, function(err, result, ctx, config)
				completed = completed + 1
				if err then
					print(string.format("❌ %s error: %s", client.name, tostring(err)))
				elseif result and #result > 0 then
					print(string.format("✅ %s: %d code actions", client.name, #result))
					for i, action in ipairs(result) do
						print(string.format("   %d. %s", i, action.title or "Unnamed action"))
					end
					table.insert(results, { client = client.name, actions = result })
				else
					print(string.format("⚠️  %s: No code actions", client.name))
				end

				if completed == total_clients then
					if #results == 0 then
						print("\n❌ No code actions available from any client")
						print("This is likely why you see 'no code options available'")
						print("\nPossible fixes:")
						print("1. Make sure you have syntax errors or code that needs actions")
						print("2. Try a different position in the file")
						print("3. Check if Biome is configured with rules that provide actions")
						print("4. Use <leader>i instead of <C-i> for code actions")
					end
					vim.cmd("qall!")
				end
			end, 0)
		else
			completed = completed + 1
			print(string.format("⚠️  %s: Doesn't support code actions", client.name))
			if completed == total_clients then
				vim.cmd("qall!")
			end
		end
	end
else
	print("❌ No LSP clients attached")
	vim.cmd("qall!")
end

