local action = require("wezterm").action

local M = {}

function M.apply_to_config(config)
	config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
	config.keys = {
		{
			key = "s",
			mods = "LEADER",
			action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "v",
			mods = "LEADER",
			action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "w",
			mods = "LEADER",
			action = action.ShowLauncher,
		},
		{
			key = "m",
			mods = "LEADER",
			action = action.TogglePaneZoomState,
		},
	}
end

return M
