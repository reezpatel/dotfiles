-- Place this in your Neovim config folder
-- If using init.lua: Add to your init.lua
-- If using separate files: ~/.config/nvim/lua/plugins/lualine.lua

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "rebelot/kanagawa.nvim" },
	event = "VeryLazy", -- Load after UI is ready
	config = function()
		local kanagawa_colors = require("kanagawa.colors").setup({ theme = "dragon" })
		local theme = kanagawa_colors.theme

		local kanagawa_lualine = {
			normal = {
				a = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },
				b = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
				c = { bg = theme.ui.bg_p1, fg = theme.ui.fg },
			},
			insert = {
				a = { bg = theme.diag.ok, fg = theme.ui.bg_m3 },
				b = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
				c = { bg = theme.ui.bg_p1, fg = theme.ui.fg },
			},
			visual = {
				a = { bg = theme.syn.keyword, fg = theme.ui.bg_m3 },
				b = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
				c = { bg = theme.ui.bg_p1, fg = theme.ui.fg },
			},
			replace = {
				a = { bg = theme.syn.constant, fg = theme.ui.bg_m3 },
				b = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
				c = { bg = theme.ui.bg_p1, fg = theme.ui.fg },
			},
			command = {
				a = { bg = theme.syn.operator, fg = theme.ui.bg_m3 },
				b = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
				c = { bg = theme.ui.bg_p1, fg = theme.ui.fg },
			},
			inactive = {
				a = { bg = theme.ui.bg_m1, fg = theme.ui.fg_dim },
				b = { bg = theme.ui.bg_m1, fg = theme.ui.fg_dim },
				c = { bg = theme.ui.bg_m1, fg = theme.ui.fg_dim },
			},
		}

		require("lualine").setup({
			options = {
				theme = kanagawa_lualine,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return str:sub(1, 1)
						end,
					},
				},
				lualine_b = {
					{ "diff", colored = true },
					{ "diagnostics", sources = { "nvim_diagnostic" } },
				},
				lualine_c = {
					{ "filename", path = 1 }, -- 0 = just filename, 1 = relative path, 2 = absolute path
				},
				lualine_x = {
					{ "filetype", colored = true, icon_only = false },
					"encoding",
				},
				lualine_z = { "location" },
				lualine_y = {
					{
						function()
							local buf_clients = vim.lsp.buf_get_clients()
							if next(buf_clients) == nil then
								return "No LSP"
							else
								-- Just return the first client name
								for _, client in pairs(buf_clients) do
									return client.name
								end
							end
							return "No LSP"
						end,
						color = { fg = theme.syn.special0 },
					},
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {
				"nvim-tree",
				"toggleterm",
				"fugitive",
				"quickfix",
				"lazy",
			},
		})
	end,
}
