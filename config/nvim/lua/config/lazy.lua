-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.opt.number = true

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.undofile = true

-- relative line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.confirm = true

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>rn",
-- 	'<cmd>lua require("renamer").rename()<cr>',
-- 	{ noremap = true, silent = true }
-- )
-- vim.api.nvim_set_keymap(
-- 	"v",
-- 	"<leader>rn",
-- 	'<cmd>lua require("renamer").rename()<cr>',
-- 	{ noremap = true, silent = true }
-- )

-- Normal-mode commands
vim.keymap.set("n", "<A-Down>", ":MoveLine 1<CR>", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set("n", "<A-Up>", ":MoveLine -1<CR>", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-S-Left>", ":MoveWord -1<CR>", { noremap = true, silent = true, desc = "Move word left" })
vim.keymap.set("n", "<A-S-Right>", ":MoveWord 1<CR>", { noremap = true, silent = true, desc = "Move word right" })

-- Visual-mode commands
vim.keymap.set("x", "<A-Up>", ":MoveBlock 1<CR>", { noremap = true, silent = true, desc = "Move selected block up" })
vim.keymap.set(
	"x",
	"<A-Down>",
	":MoveBlock -1<CR>",
	{ noremap = true, silent = true, desc = "Move selected block down" }
)
vim.keymap.set(
	"v",
	"<A-Left>",
	":MoveHBlock -1<CR>",
	{ noremap = true, silent = true, desc = "Move selected block left" }
)
vim.keymap.set(
	"v",
	"<A-Right>",
	":MoveHBlock 1<CR>",
	{ noremap = true, silent = true, desc = "Move selected block right" }
)

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

-- Map leader + ss to save the current file
vim.keymap.set("n", "<leader>ss", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
