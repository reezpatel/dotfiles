return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	-- Optional dependency
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local npairs = require("nvim-autopairs")
		npairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
			fast_wrap = {
				map = "<M-e>", -- Alt+e to wrap with pairs
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0, -- Offset from pattern match
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
			enable_check_bracket_line = true, -- Don't add pairs if it already has a close pair in the same line
			enable_bracket_in_quote = true, -- Enable brackets inside quotes
			ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
			enable_moveright = true, -- Enable moving past closing pairs
			enable_afterquote = true, -- Move past quotes
			map_cr = true, -- Map the <CR> key
			map_bs = true, -- Map the <BS> key
			map_c_h = false, -- Map the <C-h> key
			map_c_w = false, -- Map the <C-w> key
		})

		require("nvim-autopairs").setup({})
		-- If you want to automatically add `(` after selecting a function or method
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		npairs.add_rules({
			require("nvim-autopairs.rule")("`", "`", { "markdown", "javascript", "typescript" }),
		})
	end,
}
