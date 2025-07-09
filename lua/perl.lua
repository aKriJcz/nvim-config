--
-- Perl integration
--

local wkey = require("which-key")

-- HTML entities coding
-- https://vim.fandom.com/wiki/HTML_entities
-- TODO: work with inline selection
vim.cmd [[
function! HTMLEncode()
perl << EOF
 use HTML::Entities;
 @pos = $curwin->Cursor();
 $line = $curbuf->Get($pos[0]);
 $encvalue = encode_entities($line);
 $curbuf->Set($pos[0],$encvalue)
EOF
endfunction

function! HTMLDecode()
perl << EOF
 use HTML::Entities;
 @pos = $curwin->Cursor();
 $line = $curbuf->Get($pos[0]);
 $encvalue = decode_entities($line);
 $curbuf->Set($pos[0],$encvalue)
EOF
endfunction
]]


wkey.add {
  { "<Leader>ehe", ":call HTMLEncode()<CR>", mode = "nv", desc = "Encode characters to HTML characters" },
  { "<Leader>ehd", ":call HTMLDecode()<CR>", mode = "nv", desc = "Decode characters from HTML characters" },
}
