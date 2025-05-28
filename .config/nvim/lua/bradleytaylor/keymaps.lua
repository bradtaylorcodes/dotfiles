vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local set = vim.keymap.set

-- cursor settings
set('n', 'J', 'mzJ`z') -- keep cursor in place when appending next line
set('n', '<C-d>', '<C-d>zz') -- keep cursor in the middle when jumping by page
set('n', '<C-u>', '<C-u>zz') -- keep cursor in the middle when jumping by page
set('n', 'n', 'nzzzv') -- keep search terms in the middle
set('n', 'N', 'Nzzzv') -- keep search terms in the middle

-- clipboard settings
set('x', '<leader>p', [["_dP]]) -- paste over without losing current register
set({ 'n', 'v' }, '<leader>y', [["+y]]) -- yank to system clipboard
set('n', '<leader>Y', [["+Y]]) -- yank to system clipboard
set({ 'n', 'v' }, '<leader>d', [["_d]]) -- delete to void register
set('n', 'x', '"_x') -- delete single character without copying into register

set('n', '<leader>ww', 'cmd set wrap!<cr>', { desc = 'Toggle word wrap' })

set('n', '<leader>x', '<cmd>!chmod +x %<cr>', { silent = true, desc = 'Make current file executable' })

set('i', '<C-c>', '<Esc>') -- gives control c all behaviors of escape
