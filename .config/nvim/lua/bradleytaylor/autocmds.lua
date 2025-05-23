vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Open help docs in a vertical split',
  group = vim.api.nvim_create_augroup('VerticalHelp', { clear = true }),
  pattern = 'help',
  callback = function()
    vim.bo.bufhidden = 'unload'
    vim.cmd 'wincmd L'
    vim.cmd '='
  end,
})

-- Check whether on Mac or Linux to define browse command for :GBrowse
local open = vim.loop.os_uname().sysname == 'Darwin' and 'open' or 'xdg-open'
vim.api.nvim_create_user_command('Browse', function(opts)
  vim.fn.system { open, opts.fargs[1] }
end, { nargs = 1 })
