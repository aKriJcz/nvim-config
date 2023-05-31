local wkey = require("which-key")
wkey.setup {}


-- Key bindings
vim.api.nvim_set_keymap('n', '<Leader>H', ':call LongLineHLToggle()<cr>', { noremap = true })

-- Moving around in command mode
--vim.api.nvim_set_keymap('c', '<C-j>', '<down>', { noremap = true })
--vim.api.nvim_set_keymap('c', '<C-k>', '<up>',   { noremap = true })

-- inoremap <C-b> <C-x><C-f>
