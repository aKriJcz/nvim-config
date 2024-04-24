local M = {}

local cmp = require('plugins/cmp')

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup{}

-- Debug LSP
-- :lua print(vim.inspect(vim.lsp.get_active_clients()))
local lspconfig = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  local opts = { noremap=true, silent=true }
  -- Enable completion triggered by <c-x><c-o>
  --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>h', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

  -- LspSaga
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>la', '<cmd>Lspsaga code_action<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lr', '<cmd>Lspsaga rename<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ln', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lp', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)

  --navic.attach(client, bufnr)
  --aerial.on_attach(client, bufnr)

  -- vim.ui.select({ 'Code Action', 'spaces' }, {
  --     prompt = 'Perform LSP action:',
  --     format_item = function(item)
  --         return "I'd like to choose " .. item
  --     end,
  -- }, function(choice)
  --     if choice == 'Code Action' then
  --       vim.lsp.buf.code_action()
  --     else
  --         --vim.o.expandtab = false
  --     end
end

local lspdef = {
  on_attach = on_attach,
  capabilities = cmp.capabilities,
}

local setup = function ()
  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  --local servers = { 'zls', 'rnix', 'texlab', 'clangd', 'zk', 'vimls', 'bashls', 'cssls' }
  local servers = { 'zls', 'texlab', 'clangd', 'zk', 'vimls', 'bashls', 'svelte', 'tsserver' }

  for _, lsp in pairs(servers) do
    lspconfig[lsp].setup(lspdef)
    --lspconfig[lsp].setup(coq.lsp_ensure_capabilities())
  end

  lspconfig.hls.setup(vim.tbl_extend("force", lspdef, {
    cmd = { "haskell-language-server", "--lsp" },
  }))

  lspconfig.perlpls.setup(vim.tbl_extend("force", lspdef, {
    --cmd = { "perl", vim.fn.systemlist("which pls")[1] },
    root_dir = function () return'/home/jirka/pgm/perl'; end,
    settings = {
      perl = {
        inc = { '/home/jirka/tcz/urdk/Registration/lib' }, -- TODO: dynamicky
        perlcritic = {
          enabled = true,
          severity = 4,
        },
      },
    },
  }))

  lspconfig.nixd.setup(vim.tbl_extend("force", lspdef, {
    --settings = {
    --},
  }))

  --lspconfig.sumneko_lua.setup(vim.tbl_extend("force", lspdef, neodev))
  lspconfig.lua_ls.setup({
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace"
        };
        workspace = {
          checkThirdParty = false,
          library = {
            ['/nix/store/kvw415nrr9ijlpizhw8sfmslmf0hmqgn-awesome-4.3/share/awesome/lib'] = true,
          }
        };
        diagnostics = {
          enable = true,
          globals = {
            "vim",
            "awesome",
            "screen",
            "client",
            "root",
          };
        }
      }
    }
  })
end



require("lspsaga").setup({
  symbol_in_winbar = {
    enable = false,
  },
  scroll_preview = {
    scroll_up = "<C-p>",
    scroll_down = "<C-n>",
  },
  lightbulb = { enable = false, },
})


M.setup = setup
M.lspdef = lspdef
return M
