local keymaps = require 'keymaps'
local tab_bar = require 'tab_bar'
local smart_splits = require 'smart_splits'

local config = {}

config.font_size = 18
config.color_scheme = 'tokyonight_night'
config.window_decorations = 'RESIZE'

-- cursor styles
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.cursor_blink_rate = 500

keymaps.apply_to_config(config)
tab_bar.apply_to_config(config)
smart_splits.apply_to_config(config)

return config
