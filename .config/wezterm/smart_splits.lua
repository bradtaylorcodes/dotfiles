local wezterm = require 'wezterm'

local M = {}

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(key)
  return {
    key = key,
    mods = 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if pane:get_user_vars().IS_NVIM == 'true' then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = 'CTRL' },
        }, pane)
      else
        win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
      end
    end),
  }
end

function M.apply_to_config(config)
  for _, v in pairs {
    split_nav 'h',
    split_nav 'j',
    split_nav 'k',
    split_nav 'l',
  } do
    table.insert(config.keys, v)
  end
end

return M
