local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

M.toggle = function(window, pane)
  local projects = {}
  local home = wezterm.home_dir
  local success, stdout, stderr = wezterm.run_child_process {
    'find',
    home .. '/personal/dotfiles',
    home .. '/personal/dotfiles/.config',
    home .. '/work',
    home .. '/personal',
    '-mindepth',
    '1',
    '-maxdepth',
    '1',
    '-type',
    'd',
  }

  if not success then
    wezterm.log_error('Failed to run find: ' .. stderr)
    return
  end

  for path in stdout:gmatch '([^\n]*)\n?' do
    local dir_name = path:match '[^/\\]+$'
    table.insert(projects, { label = path, id = dir_name })
  end

  window:perform_action(
    act.InputSelector {
      action = wezterm.action_callback(function(win, _, id, label)
        if not id and not label then
          wezterm.log_info 'Cancelled'
        else
          wezterm.log_info('Selected ' .. label)
          win:perform_action(act.SwitchToWorkspace { name = id, spawn = { cwd = label } }, pane)
        end
      end),
      fuzzy = true,
      title = 'Select project',
      choices = projects,
    },
    pane
  )
end

return M
