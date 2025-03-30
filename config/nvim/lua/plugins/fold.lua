-- In your plugins.lua or equivalent file where you define lazy.nvim plugins
return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			-- Using ufo provider need remap `zR` and `zM`
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

			-- Option 2: nvim lsp as LSP client
			-- Tell the server the capability of foldingRange,
			-- Neovim hasn't added foldingRange to default capabilities, users must add it manually

			-- Setup for LSP clients to support folding
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			-- Apply capabilities to existing language servers
			-- Note: In lazy.nvim, you'll typically configure this in your LSP setup
			-- This is just for existing/already setup LSP clients
			local language_servers = vim.lsp.get_active_clients() -- or list servers manually like {'gopls', 'clangd'}
			for _, ls in ipairs(language_servers) do
				ls.config.capabilities = vim.tbl_deep_extend("force", ls.config.capabilities or {}, capabilities)
			end

			-- Setup UFO
			require("ufo").setup()
		end,
	},

	-- Example of how to configure LSP with the folding capabilities
	-- Add this to your lspconfig setup or adjust your existing one
	{
		"neovim/nvim-lspconfig",
		-- other lspconfig options...
		config = function()
			-- Your existing LSP config...

			-- Add folding capabilities to all language servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			-- Example server setup with folding capabilities
			-- require('lspconfig').lua_ls.setup({
			--   capabilities = capabilities,
			--   -- other settings...
			-- })

			-- For other language servers, add similar configuration
		end,
	},
}
