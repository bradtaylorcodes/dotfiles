return {
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    dependencies = {
      { 'rafamadriz/friendly-snippets' },
    },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      -- friendly-snippets - enable standardized comments snippets
      for ft, snips in pairs {
        typescript = { 'tsdoc' },
        javascript = { 'jsdoc' },
        lua = { 'luadoc' },
        python = { 'pydoc' },
      } do
        require('luasnip').filetype_extend(ft, snips)
      end

      local ls = require 'luasnip'
      ls.setup {
        history = true,
      }

      vim.keymap.set({ 'i', 's' }, '<C-L>', function()
        ls.jump(1)
      end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<C-H>', function()
        ls.jump(-1)
      end, { silent = true })
    end,
  },
}
