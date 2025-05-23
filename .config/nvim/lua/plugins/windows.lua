return {
  'anuvyklack/windows.nvim',
  dependencies = { 'anuvyklack/middleclass' },
  config = function()
    require('windows').setup {
      autowidth = {
        enable = false,
      },
      animation = {
        enable = false,
      },
    }

    vim.keymap.set('n', '<C-w>m', vim.cmd.WindowsMaximize, { desc = 'Toggle window maximizer' })
  end,
}
