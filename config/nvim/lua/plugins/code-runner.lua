return {
	-- Your other plugins...

	{
		"CRAG666/code_runner.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("code_runner").setup({
				-- Choose whether to run in a terminal tab, split, or floating window
				mode = "term", -- Available options: term, tab, float, toggleterm

				-- Focus on runner window after execution
				focus = true,

				-- Filetype specific commands
				filetype = {
					javascript = "node",
					typescript = "tsc",
					javascriptreact = "node",
					typescriptreact = "tsc",
					java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
					c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
					cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
					python = "python -u",
					rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
					go = "go run",
					lua = "lua",
					sh = "bash",
				},

				-- Advanced configuration for terminal
				term = {
					-- Position for the terminal
					position = "bot", -- Available options: bot, top, vert, float
					size = 10, -- Terminal height or width depending on position
				},

				-- Key mappings within setup
				key_mappings = {
					execute = "<leader>r", -- Run current file
					quit = "q", -- Quit the runner window
					close = "<C-w>k", -- Close the runner window
				},
			})

			-- You can also set up keymaps here outside of the setup function
			vim.keymap.set("n", "<leader>rr", ":RunCode<CR>", { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>rp", ":RunProject<CR>", { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>rc", ":RunClose<CR>", { noremap = true, silent = true })
		end,
	},

	-- More plugins...
}
