return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    -- 'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'b0o/schemastore.nvim', -- access to schemastore catalog for json
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local set = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
        end
        local builtin = require 'telescope.builtin'

        -- map('gd', builtin.lsp_definitions, 'Go to definition')
        set('gd', vim.lsp.buf.definition, 'Go to definition')
        set('gr', builtin.lsp_references, 'Show list of references')
        set('gI', builtin.lsp_implementations, 'Go to implementation')
        set('<leader>ds', builtin.lsp_document_symbols, 'Show document symbols')
        set('<leader>ws', builtin.lsp_dynamic_workspace_symbols, 'Show workspace symbols')
        set('<leader>rn', vim.lsp.buf.rename, 'Rename')
        set('<leader>ca', vim.lsp.buf.code_action, 'Code action')
        set('gD', vim.lsp.buf.declaration, 'Go to declaration')
        set('K', function()
          vim.lsp.buf.hover { border = 'rounded' }
        end, 'Show hover docs')
      end,
    })

    local servers = {
      lua_ls = {},
      html = {},
      marksman = {},
      -- gopls = {},
      dockerls = {},
      ts_ls = {
        settings = {
          implicitProjectConfiguration = {
            checkJs = true,
          },
        },
      },
      eslint = {},
      pyright = {},
      cssls = {},
      tailwindcss = {},
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      },
      astro = {},
      jdtls = {},
    }

    require('mason').setup {}
    require('mason-lspconfig').setup {
      ensure_installed = vim.tbl_keys(servers),
      automatic_enable = false,
    }

    for server_name, config in pairs(servers) do
      vim.lsp.config(server_name, config)
      vim.lsp.enable(server_name)
    end

    -- this is for when mason-tool-installer gets updated
    -- local ensure_installed = vim.tbl_keys(servers or {})
    -- additional tools that aren't LSP servers
    -- vim.list_extend(ensure_installed, {
    --   'stylua',
    --   'prettier',
    -- })
  end,
}
