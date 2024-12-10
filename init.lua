-- https://neovim.io/doc/user/filetype.html
-- https://github.com/brainfucksec/neovim-lua/tree/main/nvim

-- TODO: Migrate to LuaSnip
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#loaders
-- https://gist.github.com/davidatsurge/9873d9cb1781f1a37c0f25d24cb1b3ab
-- https://cj.rs/blog/ultisnips-to-luasnip/

local set = vim.opt  -- General options

set.number = true
set.relativenumber = true

set.tabstop = 4
set.shiftwidth = 4
set.smarttab = true

set.autoindent = true
set.smartindent = true

set.backspace = 'indent,eol,start'
set.joinspaces = false
set.clipboard = 'unnamedplus'

set.ignorecase = true
set.smartcase = true

set.hlsearch = true
set.incsearch = true

set.updatetime = 2000

set.splitright = true

set.undofile = true

set.list = true
set.listchars = { tab = '» ', trail = '·' }

vim.opt.termguicolors = true
-- vim.g.rehash256 = 1
vim.cmd.colorscheme('molokaiCust')

-- Folding
set.foldmethod = 'syntax'
set.foldcolumn = '2'
set.foldlevel = 1

vim.cmd [[ highlight ColorColumn ctermbg=52 ]]
if vim.fn.exists('+colorcolumn') then
  vim.opt.colorcolumn = '80,100'
end


-- Check spelling
vim.cmd [[
let g:myLang = 0
let g:myLangList = ['nospell', 'cs,en_gb', 'cs', 'en_gb']
function MySpellLang()
  "loop through languages
  if g:myLang == 0 | setlocal nospell | endif
  if g:myLang != 0 | let &l:spelllang = g:myLangList[g:myLang] | setlocal spell | endif
  echomsg 'language:' g:myLangList[g:myLang]
  let g:myLang = g:myLang + 1
  if g:myLang >= len(g:myLangList) | let g:myLang = 0 | endif
endfunction
map <F11> :<C-U>call MySpellLang()<CR>
]]


-- Boxes
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'text', 'sh', 'conf', 'sshconfig', 'ldif' },
  command = [[ map <buffer> <F3> :'<,'>!boxes -d shell -s 80 -a c<CR> ]],
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'haskell', 'lua' },
  command = [[ map <buffer> <F3> :'<,'>!boxes -d ada-box -s 80 -a c<CR> ]],
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'java', 'groovy' },
  command = [[ map <buffer> <F3> :'<,'>!boxes -d c -s 80 -a c<CR> ]],
})
-- command -nargs=* -range Boxes :'<,'>!boxes -s 80 -a c -d <args>

vim.cmd [[
" Formatting of files
au FileType xml command! Format %!xmllint --format -
au FileType html command! Format %!tidy --indent yes --show-body-only auto
au FileType json command! Format %!jq .
au FileType sql command! -range=% Format <line1>,<line2>!sqlformat --reindent --keywords upper --identifiers lower -
]]

vim.cmd [[
au BufNewFile,BufRead *.tt :set filetype=html
]]


-- <Leader>H switches color of chars above 80
vim.cmd [[
hi OverLength ctermbg=none cterm=none
match OverLength /\%>80v/
function LongLineHLToggle()
  if !exists('w:longlinehl')
    let w:longlinehl = matchadd('ErrorMsg', '.\%>80v', 0)
    echo "Long lines highlighted"
  else
    call matchdelete(w:longlinehl)
    unl w:longlinehl
    echo "Long lines unhighlighted"
  endif
endfunction
]]


-- Mail config
vim.cmd [[
" http://brianbuccola.com/line-breaks-in-mutt-and-vim/
" Add format option 'w' to add trailing white space, indicating that paragraph
" continues on next line. This is to be used with mutt's 'text_flowed' option.
"augroup mail_trailing_whitespace
augroup mail_config
  autocmd!
  " Trailing whitespace
  autocmd FileType mail setlocal formatoptions+=w
  " Setting spell check languages
  autocmd FileType mail setlocal spell spelllang=cs,en_gb
augroup END

augroup gitcommit_config
  autocmd!
  autocmd FileType gitcommit setlocal spell spelllang=cs,en_gb
augroup END

augroup markdown_config
  autocmd!
  autocmd FileType markdown setlocal spell spelllang=cs,en_gb

  "pandoc CHANGELOG.md | w3m -T text/html -dump
  autocmd FileType markdown let g:previewer="clear ; pandoc % | w3m -T text/html -dump | less"
augroup END

let g:checkattach_filebrowser = 'ranger'
]]

vim.cmd [[
command InsertDate let z=system("date +%F") | execute "normal i".z

function Preview()
  if !exists("g:previewer")
    echoerr "g:previewer is not set for this type of file!"
    return
  endif

  if has("nvim")
    execute "!" . g:previewer
  else
    execute "silent !" . g:previewer
    redraw!
  endif
endfunction
command Preview call Preview()

function SvnDiffSplit()
  let g:nrrw_rgn_protect = 'n'
  let saved_cursor = getcurpos()
  call setpos('.', [0, 1, 0, 0])

  let works = search("<<<<<<< .working", "Wc")
  let worke = search("||||||| .old", "Wc")
  if works < 1 || worke < 1
    echoe "Cannot find .working part!"
    return
  endif
  let works = works + 1
  let worke = worke - 1

  let news = search("=======", "Wc")
  let newe = search(">>>>>>> .new", "Wc")
  if news < 1 || newe < 1
    echoe "Cannot find .new part!"
    return
  endif
  let news = news + 1
  let newe = newe - 1

  execute works.','.worke "call nrrwrgn#NrrwRgn('')"
  execute "diffthis"
  execute "wincmd H"
  execute "wincmd p"
  execute news.','.newe "call nrrwrgn#NrrwRgn('')"
  execute "diffthis"
  execute "wincmd L"
  execute "wincmd p"
  execute "wincmd J"

  call setpos('.', saved_cursor)
endfunction
]]

vim.cmd [[
function! Redmine(id)
  let script=fnamemodify('~', ':p') . 'skripty/redmine.sh ' . shellescape(a:id)
  let result=system(script)
  call setline(line('.'), getline('.') . result)
endfunction
command! -nargs=+ Redmine :call Redmine(<q-args>)
]]


-- Plugin settings

-- CSV plugin
vim.b.csv_arrange_align = 'l*'

-- Syntastic
vim.g.syntastic_mode_map = {
  mode = 'passive',
  active_filetypes = { 'sh', 'java' },
  passive_filetypes = {}
}
vim.g.syntastic_always_populate_loc_list = 1
vim.g.syntastic_auto_loc_list = 1
vim.g.syntastic_java_checkers = { 'checkstyle', 'spotbugs' }
vim.g.syntastic_java_checkstyle_classpath = '/home/jirka/Downloads/tmp/checkstyle-10.3.1-all.jar'
vim.g.syntastic_java_checkstyle_conf_file = './checkstyle.xml'
vim.g.syntastic_java_spotbugs_classpath = '/home/jirka/Downloads/tmp/checkstyle-10.3.1-all.jar'
vim.g.syntastic_java_spotbugs_conf_file = './checkstyle.xml'

-- vim2hs
vim.g.haskell_conceal = 0
vim.g.haskell_conceal_enumerations = 0

-- vim-closetag
vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml,*.tmpl'
vim.g.closetag_xhtml_filenames = '*.xhtml,*.jsx'
vim.g.closetag_filetypes = 'html,xhtml,phtml'
vim.g.closetag_xhtml_filetypes = 'xhtml,jsx'
vim.g.closetag_emptyTags_caseSensitive = 1
vim.g.closetag_regions = {
  ['typescript.tsx'] = 'jsxRegion,tsxRegion',
  ['javascript.jsx'] = 'jsxRegion',
}
vim.g.closetag_shortcut = '>'
vim.g.closetag_close_shortcut = '<leader>>'

-- vimtex
vim.g.tex_flavor = 'latex'

-- ripgrep
vim.cmd [[
let g:ripgrep#root_marks = [ "." ]
command! -nargs=+ -complete=file Ripgrep :call ripgrep#search(<q-args>)
]]

-- zig.vim
vim.g.zig_fmt_autosave = 0

-- https://github.com/alvan/vim-closetag/issues/40
-- Enable vim-closetag + delimitMate functionality
vim.cmd [[
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = "*.xml,*.html,*.xhtml,*.phtml,*.php,*.erb"

" delimitMate colides with vim-closetag bug fix
au FileType eruby,xml,html,phtml,php,xhtml,js let b:delimitMate_matchpairs = "(:),[:],{:}"

" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'xml,html,xhtml,phtml,eruby'
]]

-- https://www.reddit.com/r/neovim/comments/suy5j7/highlight_yanked_text/
-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd[[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
]]

-- vim-svelte-plugin
vim.g.vim_svelte_plugin_use_typescript = 1
vim.g.vim_svelte_plugin_use_less = 1


require("keybindings")
require("plugins")

-- TODO
-- 
--let g:tex_fold_enabled=1
--let g:vimsyn_folding='af'
--let g:xml_syntax_folding = 1
--
-- Cursor restore?
--
