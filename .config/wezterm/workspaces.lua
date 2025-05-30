local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

function M.apply_to_config(config)
  table.insert(config.keys, {
    key = 's',
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      local workspaces = wezterm.mux.get_workspace_names()

      local choices = {}
      for _, name in ipairs(workspaces) do
        table.insert(choices, { id = name, label = name })
      end

      window:perform_action(
        act.InputSelector {
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            if not id and not label then
              wezterm.log_info 'cancelled'
            else
              wezterm.log_info('id = ' .. id)
              wezterm.log_info('label = ' .. label)
              inner_window:perform_action(
                act.SwitchToWorkspace {
                  name = label,
                  spawn = {
                    label = 'Workspace: ' .. label,
                    cwd = id,
                  },
                },
                inner_pane
              )
            end
          end),
          title = 'Choose Workspace',
          choices = choices,
        },
        pane
      )
    end),
  })
end

return M
