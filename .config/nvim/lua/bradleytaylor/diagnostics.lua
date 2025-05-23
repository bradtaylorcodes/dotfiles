local set = vim.keymap.set

vim.diagnostic.config {
  float = { border = 'rounded', header = '' },
  virtual_text = {
    prefix = '■ ', -- Could be '●', '▎', 'x', '■', , 
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
}

set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Previous diagnostic message' })
set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Next diagnostic message' })
set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic error' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })
