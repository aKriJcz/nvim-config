" Vim color file
"
" Author: Jiří Kratochvíl <kratochvil.jiri.cz@gmail.com>
"
" Note: Based on the monokai theme by Tomas Restrepo and combined with theme
" https://github.com/patstockwell/vim-monokai-tasty

hi clear

if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="molokaj"

set background=dark


" Highlight function helper {{{
function! Highlight(group, colour)
  let l:foreground = exists('a:colour.fg')
        \ ? ' ctermfg=' . a:colour.fg.cterm . ' guifg=' . a:colour.fg.gui
        \ : ''
  let l:background = exists('a:colour.bg')
        \ ? ' ctermbg=' . a:colour.bg.cterm . ' guibg=' . a:colour.bg.gui
        \ : ''
  let l:style = exists('a:colour.style')
        \ ? ' cterm=' . a:colour.style.cterm . ' gui=' . a:colour.style.gui
        \ : ''
  let l:highlight_command = 'hi '
        \ . a:group . l:foreground . l:background . l:style
  exec l:highlight_command
endfunction
" }}}


" Colours {{{
"let s:light_green = { 'cterm': 118, 'gui': '#87FF00' }
"let s:light_blue = { 'cterm': 81, 'gui': '#66D9EF' }
"let s:magenta = { 'cterm': 161, 'gui': '#F92672' }
let s:light_green = { 'cterm': 148, 'gui': '#AFD75F' }
let s:magenta = { 'cterm': 161, 'gui': '#FF5F5F' }
let s:light_blue = { 'cterm': 81, 'gui': '#5FD7FF' }
let s:purple = { 'cterm': 135, 'gui': '#AE81FF' }
let s:orange = { 'cterm': 208, 'gui': '#FD971F' }
let s:beige = { 'cterm': 144, 'gui': '#E6DB74' }
"let s:red = { 'cterm': 9, 'gui': '#FF0000' }
let s:yellow = { 'cterm': 228, 'gui': '#FFEA32' }

let s:white = { 'cterm': 253, 'gui': '#FFFFFF' }
let s:black = { 'cterm': 16, 'gui': '#000000' }
let s:off_white = { 'cterm': 241, 'gui': '#CCCCCC' }

let s:danger = { 'cterm': 219, 'gui': '#960050' }
let s:danger_bg = { 'cterm': 89, 'gui': '#1E0010' }
let s:dark_highlight = { 'cterm': 0, 'gui': '#0B0E10' }

" Git diff colours.
let s:diff_delete_fg = { 'cterm': 162, 'gui': '#C80050' }
let s:diff_delete_bg = { 'cterm': 53, 'gui': '#1E0010' }
let s:diff_add_fg = { 'cterm': 22, 'gui': '#69F684' }
let s:diff_add_bg = { 'cterm': 24, 'gui': '#13354A' }
let s:diff_text = { 'cterm': 33, 'gui': '#3B3E54' }
let s:diff_change = { 'cterm': 60, 'gui': '#252b3e' }

let s:selection_visual_fg = { 'cterm': 123, 'gui': '#44CEEF' }
let s:selection_visual_bg = { 'cterm': 25, 'gui': '#3E515D' }

let s:light_grey = { 'cterm': 250, 'gui': '#BCBCBC' }
let s:grey = { 'cterm': 244, 'gui': '#808080' }
let s:dark_grey = { 'cterm': 59, 'gui': '#5F5F5F' }
let s:darker_grey = { 'cterm': 238, 'gui': '#444444' }
let s:light_charcoal = { 'cterm': 238, 'gui': '#2B2B2B' }
let s:charcoal = { 'cterm': 235, 'gui': '#262626' }
let s:almost_black = { 'cterm': 233, 'gui': '#1B1C1D' }

let s:none = { 'cterm': 'NONE', 'gui': 'NONE' }
let s:bold = { 'cterm': 'bold', 'gui': 'bold' }
let s:underline = { 'cterm': 'underline', 'gui': 'underline' }
let s:bold_underline = { 'cterm': 'bold,underline', 'gui': 'bold,underline' }
let s:italic = { 'cterm': 'italic', 'gui': 'italic' }
let s:undercurl = { 'cterm': 'undercurl', 'gui': 'undercurl' }

let s:bg = s:almost_black
" }}}

"cursor size/type in normal mode
set guicursor=n-v-c:block-Cursor

"insert mode
set guicursor+=i-ci:ver25-iCursor


call Highlight('Normal', { 'fg': s:white, 'bg': s:almost_black, 'style': s:none })
call Highlight('Comment', { 'fg': s:grey, 'bg': s:none, 'style': s:none })
call Highlight('Boolean', { 'fg': s:purple, 'bg': s:none, 'style': s:none })
call Highlight('Character', { 'fg': s:beige, 'bg': s:none, 'style': s:none })
call Highlight('Number', { 'fg': s:purple, 'bg': s:none, 'style': s:none })
call Highlight('String', { 'fg': s:beige, 'bg': s:none, 'style': s:none })
call Highlight('Conditional', { 'fg': s:magenta, 'bg': s:none, 'style': s:bold })
call Highlight('Constant', { 'fg': s:purple, 'bg': s:none, 'style': s:bold })
call Highlight('Cursor', { 'fg': s:dark_grey, 'bg': s:light_blue, 'style': s:bold })
call Highlight('iCursor', { 'fg': s:white, 'bg': s:white, 'style': s:bold })
call Highlight('Define', { 'fg': s:light_blue, 'bg': s:none, 'style': s:none })
call Highlight('Delimiter', { 'fg': s:grey, 'bg': s:none, 'style': s:none })
call Highlight('Added', { 'fg': s:diff_add_fg, 'bg': s:diff_add_bg, 'style': s:none })
call Highlight('DiffAdd', { 'fg': s:diff_add_fg, 'bg': s:diff_add_bg, 'style': s:none })
call Highlight('DiffChange', { 'fg': s:grey, 'bg': s:darker_grey, 'style': s:none })
call Highlight('Removed', { 'fg': s:diff_delete_fg, 'bg': s:diff_delete_bg, 'style': s:none })
call Highlight('DiffDelete', { 'fg': s:diff_delete_fg, 'bg': s:diff_delete_bg, 'style': s:none })
"hi DiffText                      guibg=#4C4745 gui=italic,bold
call Highlight('DiffText', { 'fg': s:none, 'bg': s:dark_grey, 'style': s:bold })

call Highlight('Directory', { 'fg': s:light_green, 'bg': s:none, 'style': s:bold })
call Highlight('Error', { 'fg': s:danger, 'bg': s:danger_bg, 'style': s:bold })
call Highlight('ErrorMsg', { 'fg': s:magenta, 'bg': s:almost_black, 'style': s:bold })
call Highlight('Exception', { 'fg': s:light_green, 'bg': s:none, 'style': s:bold })
call Highlight('Float', { 'fg': s:purple, 'bg': s:none, 'style': s:none })
call Highlight('FoldColumn', { 'fg': s:grey, 'bg': s:black, 'style': s:none })
call Highlight('Folded', { 'fg': s:grey, 'bg': s:black, 'style': s:none })
call Highlight('Function', { 'fg': s:light_green, 'bg': s:none, 'style': s:none })
call Highlight('Identifier', { 'fg': s:orange, 'bg': s:none, 'style': s:none })
"hi Ignore          guifg=#808080 guibg=bg
call Highlight('Ignore', { 'fg': s:grey, 'bg': s:none, 'style': s:none })
call Highlight('IncSearch', { 'fg': s:yellow, 'bg': s:black, 'style': s:none })

call Highlight('Keyword', { 'fg': s:magenta, 'bg': s:none, 'style': s:bold })
call Highlight('Label', { 'fg': s:beige, 'bg': s:none, 'style': s:none })
call Highlight('SpecialKey', { 'fg': s:light_blue, 'bg': s:none, 'style': s:italic })

call Highlight('MatchParen', { 'fg': s:black, 'bg': s:orange, 'style': s:bold })
call Highlight('ModeMsg', { 'fg': s:beige, 'bg': s:none, 'style': s:none })
call Highlight('MoreMsg', { 'fg': s:beige, 'bg': s:none, 'style': s:none })
call Highlight('Operator', { 'fg': s:magenta, 'bg': s:none, 'style': s:none })

" complete menu
call Highlight('Pmenu', { 'fg': s:light_blue, 'bg': s:black, 'style': s:none })
call Highlight('PmenuSel', { 'fg': s:black, 'bg': s:grey, 'style': s:none })
call Highlight('PmenuSbar', { 'fg': s:none, 'bg': s:black, 'style': s:none }) " popup menu scrollbar
call Highlight('PmenuThumb', { 'fg': s:light_blue, 'bg': s:none, 'style': s:none })

call Highlight('PreCondit', { 'fg': s:light_green, 'bg': s:none, 'style': s:bold })
call Highlight('PreProc', { 'fg': s:yellow, 'bg': s:none, 'style': s:none })
call Highlight('Question', { 'fg': s:light_blue, 'bg': s:none, 'style': s:none })
call Highlight('Repeat', { 'fg': s:magenta, 'bg': s:none, 'style': s:bold })
call Highlight('Search', { 'fg': s:white, 'bg': s:darker_grey, 'style': s:bold })

" marks column
call Highlight('SignColumn', { 'fg': s:light_green, 'bg': s:almost_black, 'style': s:bold })
call Highlight('SpecialChar', { 'fg': s:magenta, 'bg': s:none, 'style': s:bold })
call Highlight('SpecialComment', { 'fg': s:white, 'bg': s:none, 'style': s:bold })
call Highlight('Special', { 'fg': s:light_blue, 'bg': s:none, 'style': s:italic })
call Highlight('Statement', { 'fg': s:magenta, 'bg': s:none, 'style': s:bold })
call Highlight('StatusLineNC', { 'fg': s:grey, 'bg': s:almost_black, 'style': s:none })
call Highlight('StorageClass', { 'fg': s:magenta, 'bg': s:none, 'style': s:italic })
call Highlight('Structure', { 'fg': s:light_blue, 'bg': s:none, 'style': s:none })
call Highlight('Tag', { 'fg': s:magenta, 'bg': s:none, 'style': s:italic })
call Highlight('Title', { 'fg': s:orange, 'bg': s:none, 'style': s:none })
call Highlight('Todo', { 'fg': s:white, 'bg': s:none, 'style': s:bold })

call Highlight('Typedef', { 'fg': s:light_blue, 'bg': s:none, 'style': s:none })
call Highlight('Type', { 'fg': s:light_blue, 'bg': s:none, 'style': s:none })
call Highlight('Underlined', { 'fg': s:grey, 'bg': s:none, 'style': s:underline })

"hi VertSplit       guifg=#808080 guibg=#080808 gui=bold
call Highlight('VertSplit', { 'fg': s:grey, 'bg': s:almost_black, 'style': s:bold })
call Highlight('Visual', { 'fg': s:selection_visual_fg, 'bg': s:selection_visual_bg, 'style': s:none })
call Highlight('WarningMsg', { 'fg': s:white, 'bg': s:darker_grey, 'style': s:bold })
call Highlight('WildMenu', { 'fg': s:light_blue, 'bg': s:black, 'style': s:none })

call Highlight('LineNr', { 'fg': s:light_grey, 'bg': s:almost_black, 'style': s:none })
call Highlight('NonText', { 'fg': s:light_grey, 'bg': s:almost_black, 'style': s:none })


" Specific file type overrides {{{
call Highlight('javaExternal', { 'fg': s:magenta, 'bg': s:none, 'style': s:none })

call Highlight('xmlTag', { 'fg': s:magenta, 'bg': s:none, 'style': s:none })
call Highlight('xmlTagName', { 'fg': s:magenta, 'bg': s:none, 'style': s:none })
" }}}



if has("spell")
    hi SpellBad    guisp=#FF0000 gui=undercurl
    hi SpellCap    guisp=#7070F0 gui=undercurl
    hi SpellLocal  guisp=#70F0F0 gui=undercurl
    hi SpellRare   guisp=#FFFFFF gui=undercurl
endif


hi Debug           guifg=#BCA3A3               gui=bold
hi Macro           guifg=#C4BE89               gui=italic
hi VisualNOS                     guibg=#403D3D
hi CursorLine                    guibg=#293739
hi CursorColumn                  guibg=#293739

"
" Support for 256-color terminal
"
if &t_Co > 255
   "hi Cursor          ctermfg=16  ctermbg=253
   "hi DiffText                    ctermbg=102 cterm=bold
   hi Debug           ctermfg=225               cterm=bold
   hi Macro           ctermfg=193
   hi VisualNOS                   ctermbg=238
   hi CursorLine                  ctermbg=234   cterm=none
   hi CursorColumn                ctermbg=234
end
