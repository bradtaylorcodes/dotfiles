return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'b0o/schemastore.nvim', -- access to schemastore catalog for json
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        -- pyright provides better hover docs than ruff
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == 'ruff' then
          client.server_capabilities.hoverProvider = false
        end
        -- formatting is left to prettier, only in projects that use it
        if client and client.name == 'vtsls' then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        local set = function(keys, func, desc)
          -- nowait so gr doesn't wait for the built-in grn, grr, etc.
          vim.keymap.set('n', keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc, nowait = true })
        end
        local builtin = require 'telescope.builtin'

        set('gd', vim.lsp.buf.definition, 'Go to definition')
        set('gr', builtin.lsp_references, 'Show list of references')
        set('gI', builtin.lsp_implementations, 'Go to implementation')
        set('<leader>ds', builtin.lsp_document_symbols, 'Show document symbols')
        set('<leader>ws', builtin.lsp_dynamic_workspace_symbols, 'Show workspace symbols')
        set('<leader>rn', vim.lsp.buf.rename, 'Rename')
        set('<leader>ca', vim.lsp.buf.code_action, 'Code action')
        set('<leader>oi', function()
          vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' }, diagnostics = {} }, apply = true }
        end, 'Organize imports')
        set('gD', vim.lsp.buf.declaration, 'Go to declaration')
        set('K', function()
          vim.lsp.buf.hover { border = 'rounded' }
        end, 'Show hover docs')
      end,
    })

    -- vtsls sends this vscode-only command after organizing imports
    vim.lsp.commands['_typescript.didOrganizeImports'] = function() end

    local eslint_on_attach = vim.lsp.config.eslint.on_attach
    local servers = {
      lua_ls = {},
      html = {},
      marksman = {},
      gopls = {},
      dockerls = {},
      vtsls = {
        settings = {
          -- use the project's typescript version instead of the bundled one
          vtsls = { autoUseWorkspaceTsdk = true },
          ['js/ts'] = {
            implicitProjectConfig = {
              checkJs = true,
            },
          },
        },
      },
      eslint = {
        on_attach = function(client, bufnr)
          eslint_on_attach(client, bufnr)
          -- fix all auto-fixable problems on save
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
              if not (vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat) then
                vim.cmd 'LspEslintFixAll'
              end
            end,
          })
        end,
      },
      pyright = {
        settings = {
          -- let ruff handle import organizing
          pyright = { disableOrganizeImports = true },
        },
      },
      ruff = {},
      cssls = {},
      tailwindcss = {
        settings = {
          tailwindCSS = {
            -- also complete classes inside these helper calls, e.g. cn('...')
            classFunctions = { 'cn', 'clsx', 'cva', 'cx', 'tw', 'twMerge' },
          },
        },
      },
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
  end,
}
