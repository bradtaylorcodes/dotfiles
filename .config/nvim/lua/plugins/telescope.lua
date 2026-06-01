return {
  'nvim-telescope/telescope.nvim',
  branch = 'master',
  event = 'VimEnter',
  dependencies = {
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-ui-select.nvim' },
  },
  config = function()
    -- Toggle hidden files in find_files picker
    local show_hidden = false
    local function toggle_hidden_files()
      show_hidden = not show_hidden
      local prompt = require('telescope.actions.state').get_current_line()
      require('telescope.builtin').find_files { hidden = show_hidden, no_ignore = show_hidden, default_text = prompt }
    end

    require('telescope').setup {
      defaults = {
        sorting_strategy = 'ascending',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
          },
        },
        mappings = {
          i = {
            ['<C-h>'] = toggle_hidden_files,
          },
          n = {
            ['<C-h>'] = toggle_hidden_files,
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    require('telescope').load_extension 'ui-select'
    require('telescope').load_extension 'fzf'

    local set = vim.keymap.set
    local builtin = require 'telescope.builtin'

    set('n', '<leader>dl', builtin.diagnostics, { desc = 'Show diagnostics list' })
    set('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' })
    set('n', '<leader>sk', builtin.keymaps, { desc = 'Search keymaps' })
    set('n', '<C-p>', builtin.find_files, { desc = 'Search all files' })
    set('n', '<leader>sw', builtin.grep_string, { desc = 'Search word under cursor' })
    set('n', '<C-f>', builtin.live_grep, { desc = 'Grep all files' })
    set('n', '<leader><leader>', builtin.buffers, { desc = 'Search existing buffers' })
    set('n', '<space>en', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = 'Search config files' })
  end,
}
