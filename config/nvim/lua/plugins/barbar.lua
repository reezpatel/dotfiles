return {
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- insert_at_start = true,
			-- …etc.
			--
			tabpages = true,
		},
		config = function(_, opts)
			require("barbar").setup(opts)

			-- Set keymaps
			local map = vim.api.nvim_set_keymap
			local opts = { noremap = true, silent = true }

			map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
			map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)

			-- Re-order to previous/next
			map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
			map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)

			-- Goto buffer in position...
			map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
			map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
			map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
			map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
			map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
			map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
			map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
			map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
			map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
			map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)

			-- Pin/unpin buffer
			map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)

			-- Close buffer
			map("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)

			map("n", "<C-p>", "<Cmd>BufferPick<CR>", opts)

			local nvim_tree_events = require("nvim-tree.events")
			local bufferline_api = require("bufferline.api")

			local function get_tree_size()
				return require("nvim-tree.view").View.width
			end

			nvim_tree_events.subscribe("TreeOpen", function()
				bufferline_api.set_offset(get_tree_size())
			end)

			nvim_tree_events.subscribe("Resize", function()
				bufferline_api.set_offset(get_tree_size())
			end)

			nvim_tree_events.subscribe("TreeClose", function()
				bufferline_api.set_offset(0)
			end)
		end,

		version = "^1.0.0", -- optional: only update when a new 1.x version is released
	},
}
