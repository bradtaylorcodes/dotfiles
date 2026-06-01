return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    init = function()
      -- Languages to ensure are installed
      local ensure_installed = {
        'json',
        'javascript',
        'typescript',
        'tsx',
        'yaml',
        'html',
        'css',
        'markdown',
        'markdown_inline',
        'lua',
        'vim',
        'dockerfile',
        'gitignore',
        'go',
        'ruby',
        'graphql',
        'vimdoc',
        'bash',
      }

      -- Install any missing parsers on startup
      local installed = require('nvim-treesitter.config').get_installed()
      local to_install = vim.iter(ensure_installed)
          :filter(function(parser)
            return not vim.tbl_contains(installed, parser)
          end)
          :totable()

      if #to_install > 0 then
        require('nvim-treesitter').install(to_install)
      end

      -- Enable treesitter highlighting and indentation via FileType autocmd
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          if not pcall(vim.treesitter.start) then
            return
          end
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 3,
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local ok, textobjects = pcall(require, 'nvim-treesitter-textobjects.select')
          if not ok then
            return
          end

          local buf = vim.api.nvim_get_current_buf()

          local function set_keymap(mode, lhs, query, desc)
            vim.keymap.set(mode, lhs, function()
              textobjects.select_textobject(query, 'textobjects')
            end, { buffer = buf, desc = desc })
          end

          set_keymap({ 'x', 'o' }, 'af', '@function.outer', 'Select outer function')
          set_keymap({ 'x', 'o' }, 'if', '@function.inner', 'Select inner function')
          set_keymap({ 'x', 'o' }, 'ac', '@class.outer', 'Select outer class')
          set_keymap({ 'x', 'o' }, 'ic', '@class.inner', 'Select inner part of a class region')
        end,
      })
    end,
  },
}
