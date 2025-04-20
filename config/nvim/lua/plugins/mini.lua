return {
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.move").setup()
			require("mini.pairs").setup()
			require("mini.operators").setup({
				replace = {
					prefix = "P",
					reindent_linewise = true,
				},
				exchange = { disable = true },
				multiply = { disable = true },
				sort = { disable = true },
			})
			require("mini.comment").setup({
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring.internal").calculate_commentstring()
							or vim.bo.commentstring
					end,
				},
			})
			require("mini.bracketed").setup()

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			-- local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			-- statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			-- statusline.section_location = function()
			--	return "%2l:%-2v"
			--end

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
}
