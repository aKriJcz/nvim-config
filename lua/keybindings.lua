local wkey = require("which-key")
wkey.setup {}


-- Key bindings
wkey.add {
  { "<Leader>H", "<cmd>call LongLineHLToggle()<cr>", desc = "Toggle long line highlight" },
  -- FIXME: is dependent on timing between keys. Why?!
  { "yr", '<cmd>let @+ = join([expand("%"),  line(".")], ":")<cr>', desc = "Yank file:line to clipboard" },

  -- Moving around in command mode
  { "<C-j>", "<C-n>", mode = "c", silent = false, desc = "Next match" },
  { "<C-k>", "<C-p>", mode = "c", silent = false, desc = "Previous match" },

  -- Show highlight group under cursor
  { "zS", "<cmd>call SynGroup()<cr>", desc = "Show highlight group under cursor" },
}

-- inoremap <C-b> <C-x><C-f>
