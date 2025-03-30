return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- Import comment plugin
		local comment = require("Comment")

		local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

		-- Enable the plugin
		comment.setup({
			-- Set a custom mapping (default mapping is 'gcc' for line comment and 'gc' for block comment)
			mappings = {
				-- Operator-pending mapping; `gcc` for line comment, `gbc` for block comment
				basic = true,
				-- Extra mapping; gco, gcO, gcA
				extra = true,
			},

			-- Enable pre_hook (necessary for context-based commenting in files like jsx, tsx, vue etc.)
			pre_hook = ts_context_commentstring.create_pre_hook(),

			-- Determine whether to use the commentstring based on the cursor location
			sticky = true,

			-- Ignore empty lines when commenting
			ignore = "^$",

			-- Enable toggling the commented state
			toggler = {
				-- Line comment toggle keymap
				line = "gcc",
				-- Block comment toggle keymap
				block = "gbc",
			},

			-- Enable operating on the current line
			opleader = {
				-- Line comment keymap
				line = "gc",
				-- Block comment keymap
				block = "gb",
			},

			-- Enable extra mappings
			extra = {
				-- Add comment on the line above
				above = "gcO",
				-- Add comment on the line below
				below = "gco",
				-- Add comment at the end of line
				eol = "gcA",
			},

			-- Padding (space between the comment delimiter and text)
			padding = true,
		})

		-- Add custom mappings if needed
		-- Example: Map CTRL+/ to comment in both normal and visual mode
		vim.keymap.set("n", "<C-_>", "gcc", { remap = true }) -- CTRL+/ in normal mode
		vim.keymap.set("v", "<C-_>", "gc", { remap = true }) -- CTRL+/ in visual mode
	end,
}
