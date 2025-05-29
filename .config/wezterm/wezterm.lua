-- local wezterm = require("wezterm")
-- local action = wezterm.action
local keymaps = require("keymaps")

local config = {}

config.font_size = 18
config.color_scheme = "Tokyo Night"
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

-- cursor styles
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 500

keymaps.apply_to_config(config)

return config
