local wezterm = require 'wezterm'

local M = {}

function M.apply_to_config(config)
  config.tab_bar_at_bottom = true
  config.show_new_tab_button_in_tab_bar = false
  config.use_fancy_tab_bar = false

  wezterm.on('update-right-status', function(window, pane)
    local date = wezterm.strftime '%Y-%m-%d %H:%M'

    window:set_right_status(wezterm.format {
      { Text = window:active_workspace() .. '    ' },
      { Text = date },
    })
  end)
end

return M
