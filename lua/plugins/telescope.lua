local wkey = require("which-key")

local telescope = require('telescope')
local tactions = require('telescope.actions')
telescope.setup {
  defaults = {
    path_display = { "truncate" },
    mappings = {
      i = {
        ["<C-j>"] = tactions.move_selection_next,
        ["<C-k>"] = tactions.move_selection_previous,
      }
    },
  },
  extensions = {
    aerial = {
      -- Display symbols as <root>.<parent>.<symbol>
      show_nesting = true
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    }
  }
}

telescope.load_extension('dap')
telescope.load_extension('lsp_handlers')
telescope.load_extension('aerial')
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension("ui-select")

-- Disable folds in Telescope
vim.api.nvim_create_autocmd("FileType", { pattern = "TelescopeResults", command = [[setlocal nofoldenable]] })

-- telescope-dap
--map('n', '<leader>dcc',
--    '<cmd>lua require"telescope".extensions.dap.commands{}<CR>')
--map('n', '<leader>dco',
--    '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>')
--map('n', '<leader>dlb',
--    '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>')
--map('n', '<leader>dv',
--    '<cmd>lua require"telescope".extensions.dap.variables{}<CR>')
--map('n', '<leader>df',
--          '<cmd>lua require"telescope".extensions.dap.frames{}<CR>')
