local wkey = require("which-key")
wkey.setup {}


-- Key bindings
vim.api.nvim_set_keymap('n', '<Leader>H', ':call LongLineHLToggle()<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 'yr', ':let @+ = join([expand("%"),  line(".")], ":")<cr>', { noremap = true }) -- FIXME: is dependent on timing between keys. Why?!

-- Moving around in command mode
vim.api.nvim_set_keymap('c', '<C-j>', '<C-n>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-k>', '<C-p>',   { noremap = true })

-- Show highlight group under cursor
vim.api.nvim_set_keymap('n', 'zS', ':call SynGroup()<cr>', { noremap = true })

-- inoremap <C-b> <C-x><C-f>
