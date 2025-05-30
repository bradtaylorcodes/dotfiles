local keymaps = require 'keymaps'
local config = {}

config.font_size = 18
config.color_scheme = 'tokyonight_night'
config.window_decorations = 'RESIZE'
config.default_workspace = 'home'
config.enable_tab_bar = false

-- cursor styles
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.cursor_blink_rate = 500

keymaps.apply_to_config(config)

return config
