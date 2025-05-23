return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require('harpoon'):setup {}
    local set = vim.keymap.set

    set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = 'Add file to Harpoon list' })

    set('n', '<leader>h', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle Harpoon list' })

    for i = 1, 9 do
      set('n', string.format('<space>%d', i), function()
        harpoon:list():select(i)
      end, { desc = string.format('Go to Harpoon List %s', i) })
    end
  end,
}
