--
-- Perl integration
--
-- Perl package name of the current file (lib/Foo/Bar.pm -> Foo::Bar), used by ~/.vsnip/perl.json.
-- In Lua, so the snippet works without the Perl provider too.
function _G.perl_package_name()
  local path = vim.fn.expand('%:p')
  local name = path:match('lib/(.+)%.pm$')
  if not name then
    error('Cannot determine Perl module name from ' .. path .. '. Not a .pm in a lib/ dir?')
  end
  return (name:gsub('/', '::'))
end

vim.cmd [[
function! PerlPackageName() abort
  return v:lua.perl_package_name()
endfunction
]]

if vim.fn.has('perl') == 0 then
    return
end

local wkey = require("which-key")

local current_file = vim.api.nvim_get_runtime_file("lua/perl.lua", false)[1]
local base_dir = vim.fn.fnamemodify(current_file, ':h')
vim.cmd( "perlfile ".. base_dir .. "/../perl/Util.pm" )

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



vim.cmd [[
function! HTMLEncodeVisual()
perl << EOF
use Data::Dumper 'Dumper';
use HTML::Entities;

apply_selection(\&encode_entities);

EOF
endfunction
]]


wkey.add {
  { "<Leader>ehe", ":call HTMLEncodeVisual()<CR>", mode = "nv", desc = "Encode characters to HTML characters" },
  { "<Leader>ehd", ":call HTMLDecode()<CR>", mode = "nv", desc = "Decode characters from HTML characters" },
}
