return {
  'tpope/vim-rhubarb',
  'tpope/vim-fugitive',
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function set(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        set('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        set('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        set('n', '<leader>ghs', gs.stage_hunk)
        set('n', '<leader>ghr', gs.reset_hunk)
        set('v', '<leader>ghs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end)
        set('v', '<leader>ghr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end)
        set('n', '<leader>ghS', gs.stage_buffer)
        set('n', '<leader>ghu', gs.undo_stage_hunk)
        set('n', '<leader>ghR', gs.reset_buffer)
        set('n', '<leader>ghp', gs.preview_hunk)
        set('n', '<leader>ghb', function()
          gs.blame_line { full = true }
        end)
        set('n', '<leader>td', gs.toggle_current_line_blame)
        set('n', '<leader>ghd', gs.diffthis)
        set('n', '<leader>ghD', function()
          gs.diffthis '~'
        end)
        set('n', '<leader>gtd', gs.toggle_deleted)

        -- Text object
        set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },
}
