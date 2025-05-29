return {
  'tpope/vim-surround',
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end,
  },
  {
    'vim-test/vim-test',
    config = function()
      vim.keymap.set('n', '<leader>tf', vim.cmd.TestFile)
    end,
  },
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
    enabled = vim.fn.has 'nvim-0.10.0' == 1,
  },
}
