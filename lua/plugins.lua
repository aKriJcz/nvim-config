local wkey = require("which-key")

require('plugins/nvim-tree')
require('plugins/nvim-treesitter')
require('plugins/nvim-dap')
--require('plugins/telescope')
require('plugins/cmp').setup()
require('plugins/lsp').setup()

local aerial = require('aerial')
aerial.setup({
  backends = { "lsp", "treesitter", "markdown" },
  --backends = { "lsp", "treesitter" },
  --close_behavior = "global",
  attach_mode = "global",
  filter_kind = {
    "Class",
    "Constant",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Property",
    "Struct",
  },
  on_attach = function(bufnr)
    -- Toggle the aerial window with <leader>a
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>AerialToggle!<CR>', {})
    -- Jump forwards/backwards with '{' and '}'
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '{', '<cmd>AerialPrev<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '}', '<cmd>AerialNext<CR>', {})
    -- Jump up the tree with '[[' or ']]'
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>AerialPrevUp<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>AerialNextUp<CR>', {})
  end,
})

require('lualine').setup {
  options = {
    theme = "powerline"
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    --lualine_c = {'filename', { navic.get_location, cond = navic.is_available }},
    lualine_c = {{'filename', path = 1,}, { "aerial", depth = -1, }},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_b = {'branch'},
    --lualine_c = {'filename', { navic.get_location, cond = navic.is_available }},
    lualine_c = {{'filename', path = 2,}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_z = {'location'}
  },
  tabline = {
    lualine_a = {
      { "buffers",
        mode = 4,
        symbols = {
          modified = ' *',      -- Text to show when the buffer is modified
          alternate_file = '#', -- Text to show to identify the alternate file
          directory =  '',     -- Text to show when the buffer is a directory
        },
      }
    },
    lualine_x = { "windows" },
    lualine_z = { "tabs" },
  },
}

require("trouble").setup {}
wkey.register {
  ["<Space>ct"] = { ":Trouble<CR>",           "Show trouble" },
}

require('git-conflict').setup {}

require("fzf-lua").setup {
  {"fzf-vim", "telescope"},
  fzf_opts = {
    ['--layout'] = 'reverse'
  },
  winopts={
    preview={default="bat"}
  }
}

-- vim-matchup
vim.g.matchup_matchparen_enabled = 0
vim.g.matchup_surround_enabled = 1

-- vim-markdown
vim.g.vim_markdown_conceal_code_blocks = 0

-- vim-fluffy
--cmap <space> <plug>(fluffy-space)
vim.keymap.set("c", "<space>", "<plug>(fluffy-space)", { desc = "Fluffy space" })
-- NOTE: ^_ should be one character. Input it with <c-v><c-/>
--cmap ^_ <plug>(fluffy-toggle)
-- Ctrl-k
vim.keymap.set("c", "", "<plug>(fluffy-toggle)", { desc = "Fluffy toggle" })
