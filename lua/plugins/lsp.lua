local M = {}

local cmp = require('plugins/cmp')

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup{}

-- Debug LSP
-- :lua print(vim.inspect(vim.lsp.get_active_clients()))
local fzf_lua = require('fzf-lua')
local wkey = require('which-key')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  wkey.add {
    buffer = bufnr,
    { "gD",         vim.lsp.buf.declaration,     desc = "LSP declaration" },
    { "gd",         vim.lsp.buf.definition,      desc = "LSP definition" },
    { "gi",         vim.lsp.buf.implementation,  desc = "LSP implementation" },
    { "grr",        fzf_lua.lsp_references,      desc = "LSP references" },
    { "K",          vim.lsp.buf.hover,           desc = "LSP hover" },
    { "<C-h>",      vim.lsp.buf.signature_help,  desc = "LSP signature help", mode = "i" },
    { "<Leader>h",  vim.lsp.buf.signature_help,  desc = "LSP signature help" },
    { "<space>rn",  vim.lsp.buf.rename,          desc = "LSP rename" },
    { "<space>ca",  vim.lsp.buf.code_action,     desc = "LSP code action" },
    { "<space>D",   vim.lsp.buf.type_definition, desc = "LSP type definition" },

    { "<space>l",   group = "LSP" },
    { "<space>lD",  fzf_lua.lsp_declarations,    desc = "LSP declarations" },
    { "<space>ld",  fzf_lua.lsp_definitions,     desc = "LSP definitions" },
    { "<space>li",  fzf_lua.lsp_implementations, desc = "LSP implementations" },
    { "<space>ll",  fzf_lua.lsp_finder,          desc = "LSP finder" },
    { "<space>lf",  function() vim.lsp.buf.format() end, desc = "LSP format" },
    --{ "<space>la", vim.lsp.buf.code_action,    desc = "LSP code action" },

    { "<space>lw",  group = "LSP workspace" },
    { "<space>lwa", vim.lsp.buf.add_workspace_folder,    desc = "Add workspace folder" },
    { "<space>lwr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },
    { "<space>lwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      desc = "List workspace folders" },

    -- LspSaga
    { "<space>la",  "<cmd>Lspsaga code_action<CR>",          desc = "Lspsaga code action" },
    { "<space>lr",  "<cmd>Lspsaga rename<CR>",               desc = "Lspsaga rename" },
    { "<space>ln",  "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next diagnostic" },
    { "<space>lp",  "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Previous diagnostic" },
    --{ "K",        "<cmd>Lspsaga hover_doc<CR>",            desc = "Lspsaga hover" },
  }

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
  local servers = { 'zls', 'texlab', 'clangd', 'zk', 'vimls', 'bashls', 'svelte' }

  for _, lsp in pairs(servers) do
    vim.lsp.config(lsp, lspdef)
    vim.lsp.enable(lsp)
  end


  vim.lsp.config('hls', vim.tbl_extend("force", lspdef, {
    cmd = { "haskell-language-server", "--lsp" },
  }))
  vim.lsp.enable('hls')


  vim.lsp.config('perlnavigator', vim.tbl_extend("force", lspdef, {
  }))
  vim.lsp.enable('perlnavigator')


  vim.lsp.config('nixd', vim.tbl_extend("force", lspdef, {
  }))
  vim.lsp.enable('nixd')


  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace"
        };
        workspace = {
          checkThirdParty = false,
          library = {
            -- TODO: make some better path
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
  vim.lsp.enable('lua_ls')


  vim.lsp.config('ts_ls', vim.tbl_extend("force", lspdef, {
    init_options = {
      plugins = {
        {
          name = "typescript-svelte-plugin",
          -- TODO: make some better path
          -- npm config set prefix /home/jirka/node_packages
          -- npm install -g typescript-svelte-plugin
          location = "/home/jirka/node_packages/lib/node_modules/typescript-svelte-plugin",
          languages = {"javascript", "typescript"},
        },
      },
    },
  }))
  vim.lsp.enable('ts_ls')

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
