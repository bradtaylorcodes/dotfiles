local act = require('wezterm').action

local M = {}

local function map_tab_keys(config)
  for i = 1, 8 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = 'LEADER',
      action = act.ActivateTab(i - 1),
    })
  end
end

function M.apply_to_config(config)
  config.keys = {
    { key = 'd', mods = 'LEADER', action = act.ShowDebugOverlay },
  }

  map_tab_keys(config)
end

return M
