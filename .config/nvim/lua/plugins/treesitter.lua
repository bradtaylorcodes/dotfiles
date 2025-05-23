return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = {
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
      },

      -- Enable nvim-ts-autotag (use treesitter to autoclose and autorename html tags)
      autotag = { enable = true },

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },

      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
          },
        },
      },
    }

    -- enable nvim-treesitter-context
    local treesitter_context = require 'treesitter-context'

    vim.g.skip_ts_context_commentstring_module = true
    require('ts_context_commentstring').setup {
      enable_autocmd = false,
    }

    treesitter_context.setup {
      max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
    }
  end,
}
