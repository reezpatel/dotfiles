-- Add this to your lazy.nvim configuration (typically in lua/plugins/init.lua or similar)

return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2", -- Make sure to use the harpoon2 branch
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,

					-- Preserve the last marked file when exiting Neovim
					save_on_change = true,

					-- Define which parts of harpoon state should be saved
					components = {
						-- Store marks (files that are harpooned)
						"marks",

						-- Store the tmux functionality
						"tmux",

						-- Store cmd_ui (command window) state
						"cmd_ui",
					},
				},
				-- Optional: override default command handlers
				-- If you don't specify these, harpoon will use default values
				default = {
					marks = 4, -- Max number of marks to show in UI
				},
			})

			-- Basic keymaps for managing marks
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			-- You can navigate using these keys while within Telescope

			-- Set up keymaps
			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Harpoon: Add file" })
			--
			-- -- Toggle quick menu
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Harpoon: Toggle quick menu" })

			-- Toggle Telescope view (if Telescope is installed)
			vim.keymap.set("n", "<C-S-e>", function()
				toggle_telescope(harpoon:list())
			end, { desc = "Harpoon: Open in Telescope" })

			-- -- Navigate to files by index
			-- 	vim.keymap.set("n", "<C-h>", function()
			-- 		harpoon:list():select(1)
			-- 	end, { desc = "Harpoon: Go to file 1" })
			-- 	vim.keymap.set("n", "<C-j>", function()
			-- 		harpoon:list():select(2)
			-- 	end, { desc = "Harpoon: Go to file 2" })
			-- 	vim.keymap.set("n", "<C-k>", function()
			-- 		harpoon:list():select(3)
			-- 	end, { desc = "Harpoon: Go to file 3" })
			-- 	vim.keymap.set("n", "<C-l>", function()
			-- 		harpoon:list():select(4)
			-- 	end, { desc = "Harpoon: Go to file 4" })

			-- Navigate through marks sequentially
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end, { desc = "Harpoon: Go to previous mark" })
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end, { desc = "Harpoon: Go to next mark" })

			-- Remove current file from harpoon list
			vim.keymap.set("n", "<leader>hr", function()
				harpoon:list():remove()
			end, { desc = "Harpoon: Remove current file" })

			-- Clear all marks
			vim.keymap.set("n", "<leader>hc", function()
				harpoon:list():clear()
			end, { desc = "Harpoon: Clear all marks" })

			-- Optional: For tmux integration
			-- You can navigate to specific tmux windows instead of files
			vim.keymap.set("n", "<leader>ht", function()
				harpoon.tmux:gotoTerminal(1)
			end, { desc = "Harpoon: Go to tmux terminal 1" })

			-- Optional: Send command to a tmux window
			vim.keymap.set("n", "<leader>hx", function()
				harpoon.tmux:sendCommand(1, "ls -la")
			end, { desc = "Harpoon: Send command to tmux terminal 1" })
		end,
	},
}
