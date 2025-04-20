return {
	{
		"gelguy/wilder.nvim",
		event = "CmdlineEnter",
		dependencies = {
			"romgrk/fzy-lua-native", -- optional for improved fuzzy finding
		},
		config = function()
			local wilder = require("wilder")
			wilder.setup({
				modes = { ":", "/", "?" },
			})

			-- Enable fuzzy matching for commands and buffers
			wilder.set_option("pipeline", {
				wilder.branch(
					wilder.python_file_finder_pipeline({
						file_command = function(_, arg)
							if string.find(arg, ".") ~= nil then
								return { "fd", "-tf", "-H" }
							else
								return { "fd", "-tf" }
							end
						end,
						dir_command = { "fd", "-td" },
						filters = { "cpsm_filter" },
					}),
					wilder.substitute_pipeline({
						pipeline = wilder.python_search_pipeline({
							pattern = wilder.python_fuzzy_pattern(),
							sorter = wilder.python_difflib_sorter(),
							engine = "re",
						}),
					}),
					wilder.cmdline_pipeline({
						fuzzy = 1,
						fuzzy_filter = wilder.lua_fzy_filter(),
					}),
					wilder.python_search_pipeline({
						pattern = wilder.python_fuzzy_pattern(),
						sorter = wilder.python_difflib_sorter(),
						engine = "re",
					})
				),
			})

			-- Use popup menu for wildmenu display
			wilder.set_option(
				"renderer",
				wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
					highlights = {
						border = "Normal",
						accent = wilder.make_hl(
							"WilderAccent",
							"Pmenu",
							{ { a = 1 }, { a = 1 }, { foreground = "#f4468f" } }
						),
					},
					border = "rounded",
					left = { " ", wilder.popupmenu_devicons() },
					right = { " ", wilder.popupmenu_scrollbar() },
				}))
			)
		end,
	},
}
