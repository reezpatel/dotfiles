return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TodoTelescope", "TodoTrouble", "TodoLocList", "TodoQuickFix" },
	keys = {
		{ "<leader>sc", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
		{ "<leader>xT", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
	},
	opts = {},
}
