local M = {}

-- Setup nvim-cmp.
local cmp = require('cmp')

local setup = function()
  cmp.setup({

    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },

    mapping = {
      --['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      --['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-n>'] = cmp.mapping.scroll_docs(4),
      ['<C-p>'] = cmp.mapping.scroll_docs(-4),
      --['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      --['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
      ['<C-s>'] = cmp.mapping.complete({ }),
      ['<C-o>'] = cmp.mapping.complete({
        config = {
          sources = {
            { name = 'copilot' } -- Copilot only triggers on <C-o>
          }
        }
      }),
    },

    sources = cmp.config.sources({
      { name = 'vsnip', priority = 1000 }, -- For vsnip users.
      { name = 'nvim_lsp', priority = 900 },
      { name = 'dbee', priority = 700 },
      { name = 'emoji', priority = 200 },
    }, { -- When no completion is available from first block
      { name = 'path' },
      { name = 'buffer', keyword_length = 3 },
      --{ name = 'rg' },
      --{ name = 'nvim_lua' }, -- cmp-nvim-lua
    }),

    window = {
      documentation = {
        max_height = 100
      },
    },

  })

  vim.cmd [[
  " vsnip
  imap <expr> <leader><v>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
  smap <expr> <leader><v>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
  "imap <expr> <Tab>   vsnip#jumpable(1)  ? "<Plug>(vsnip-jump-next)" : "<Tab>"
  "imap <expr> <S-Tab> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"
  imap <expr> <S-Tab> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<Plug>delimitMateS-Tab"
  smap <expr> <Tab>   vsnip#jumpable(1)  ? "<Plug>(vsnip-jump-next)" : "<Tab>"
  smap <expr> <S-Tab> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"
  ]]
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.document_formatting = false

M.setup = setup
M.capabilities = capabilities

return M
