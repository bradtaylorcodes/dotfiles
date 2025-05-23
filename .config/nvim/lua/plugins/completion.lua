return {
  'saghen/blink.cmp',
  dependencies = {
    { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    'rafamadriz/friendly-snippets',
    'onsails/lspkind.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'default' },
    snippets = { preset = 'luasnip' },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      documentation = {
        window = { border = 'rounded' },
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      accept = { auto_brackets = { enabled = false } },
      -- use nvim-web-devicons
      menu = {
        draw = {
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                  local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                else
                  icon = require('lspkind').symbolic(ctx.kind, {
                    mode = 'symbol',
                  })
                end

                return icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                  local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },
          },
        },
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      -- this makes the buffer source always show even when LSP source returns items
      providers = {
        lsp = { fallbacks = {} },
      },
    },
    signature = {
      enabled = true,
      window = {
        show_documentation = false,
      },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
