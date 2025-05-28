local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font_size = 18
config.color_scheme = "Tokyo Night"
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

-- cursor styles
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 600

return config
