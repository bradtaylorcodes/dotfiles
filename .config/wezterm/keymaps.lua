local action = require("wezterm").action

local M = {}

local function map_tab_keys(config)
	for i = 1, 8 do
		table.insert(config.keys, {
			key = tostring(i),
			mods = "LEADER",
			action = action.ActivateTab(i - 1),
		})
	end
end

function M.apply_to_config(config)
	config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
	config.keys = {
		{
			key = "v",
			mods = "LEADER",
			action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "|",
			mods = "LEADER",
			action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "s",
			mods = "LEADER",
			action = action.ShowLauncher,
		},
		{
			key = "m",
			mods = "LEADER",
			action = action.TogglePaneZoomState,
		},
		{
			key = "c",
			mods = "CTRL",
			action = action.SendKey({ key = "Escape" }),
		},
		{
			key = "c",
			mods = "LEADER",
			action = action.SpawnTab("CurrentPaneDomain"),
		},
	}

	map_tab_keys(config)
end

return M
