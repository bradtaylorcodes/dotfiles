local wezterm = require(".config.wezterm.wezterm")
local action = wezterm.action

local config = wezterm.config_builder()

config.font_size = 18
config.color_scheme = "Tokyo Night"
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

-- cursor styles
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 500

-- keymaps
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
	{ key = "s", mods = "LEADER", action = wezterm.action.ShowLauncher },
}

return config
