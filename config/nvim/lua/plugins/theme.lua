return {
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("github-theme").setup({

				options = {
					darken = {
						sidebars = {
							list = { "qf", "vista_kind", "terminal", "packer" },
						},
					},
					-- Make the theme more vibrant
					transparent = false,
					dim_inactive = false,
					styles = {
						comments = "bold",
						keywords = "bold",
						functions = "bold",
						strings = "bold",
						variables = "bold",
					},
				},

				-- Updated color palettes for more vibrancy
				specs = {
					-- Customize the color palette for more vibrancy
					dark = {
						syntax = {
							keyword = "#ff5c8f", -- More vibrant pink for keywords
							func = "#b78aff", -- More vibrant purple for functions
							string = "#79d618", -- More vibrant green for strings
							comment = "#6a737d", -- Keep comments subtle
						},
					},
				},

				-- Updated syntax highlighting groups
				groups = {
					dark = {
						Normal = { bg = "#0d1117" }, -- Slightly darker background for contrast
						Comment = { fg = "#6a737d", style = "bold" },
						Keyword = { fg = "#ff5c8f", style = "bold" },
						String = { fg = "#79d618", style = "bold" },
						["@function"] = { fg = "#b78aff", style = "bold" },
						["@variable"] = { fg = "#e6edf3" },
					},
				},
			})
			vim.cmd("colorscheme github_dark_tritanopia")
			vim.opt.termguicolors = true
			vim.opt.guifont = "GeistMono Nerd Font:h13:w400"
			vim.opt.guifontwide = "GeistMono Nerd Font:h13:w400"

			-- Enable font ligatures if your GUI supports it
			vim.g.neovide_ligatures = 1 -- For Neovide
		end,
	},
}
