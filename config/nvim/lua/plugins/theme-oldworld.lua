return {
	{
		"mellow-theme/mellow.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"dgox16/oldworld.nvim",
		lazy = false,
		priority = 1000, -- Ensures it loads early, before other plugins
		config = function()
			-- Set moonfly as your colorscheme
			vim.cmd("colorscheme kanagawa-dragon")
		end,
	},
}
