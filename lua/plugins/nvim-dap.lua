-- nvim-dap
-- https://github.com/mfussenegger/nvim-dap
local wkey = require("which-key")
local dap = require("dap")

dap.configurations.lua = {
  {
    type = 'nlua', 
    request = 'attach',
    name = "Attach to running Neovim instance",
    host = function()
      local value = vim.fn.input('Host [127.0.0.1]: ')
      if value ~= "" then
        return value
      end
      return '127.0.0.1'
    end,
    port = function()
      local val = tonumber(vim.fn.input('Port: '))
      assert(val, "Please provide a port number")
      return val
    end,
  }
}
dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host, port = config.port })
end

--map("n", "<F4>", ":lua require('dapui').toggle()<CR>")
--map("n", "<F5>", ":lua require('dap').toggle_breakpoint()<CR>")
--map("n", "<F6>", ":lua require('dap').step_into()<CR>")
--map("n", "<F7>", ":lua require('dap').step_over()<CR>")
--map("n", "<F8>", ":lua require('dap').step_out()<CR>")
--map("n", "<F9>", ":lua require('dap').continue()<CR>")
--
--map("n", "<Leader>dsc", ":lua require('dap').continue()<CR>")
--map("n", "<Leader>dsv", ":lua require('dap').step_over()<CR>")
--map("n", "<Leader>dsi", ":lua require('dap').step_into()<CR>")
--map("n", "<Leader>dso", ":lua require('dap').step_out()<CR>")
--
--map("n", "<Leader>dhh", ":lua require('dap.ui.variables').hover()<CR>")
--map("v", "<Leader>dhv", ":lua require('dap.ui.variables').visual_hover()<CR>")
--
--map("n", "<Leader>duh", ":lua require('dap.ui.widgets').hover()<CR>")
--map("n", "<Leader>duf", ":lua local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.scopes)<CR>")
--
--map("n", "<Leader>dro", ":lua require('dap').repl.open()<CR>")
--map("n", "<Leader>drl", ":lua require('dap').repl.run_last()<CR>")
--
--map("n", "<Leader>dbc", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
--map("n", "<Leader>dbm", ":lua require('dap').set_breakpoint({ nil, nil, vim.fn.input('Log point message: ') })<CR>")
--map("n", "<Leader>dbt", ":lua require('dap').toggle_breakpoint()<CR>")
--
--map("n", "<Leader>dcs", ":lua require('dap.ui.variables').scopes()<CR>")
--map("n", "<Leader>di", ":lua require('dapui').toggle()<CR>")


require("dapui").setup {}
require("nvim-dap-virtual-text").setup {}

wkey.add {
  { "<F4>", ":lua require'dap'.terminate()<CR>",         desc = "DAP Terminate" },
  { "<F5>", ":lua require'dap'.toggle_breakpoint()<CR>", desc = "DAP Toggle breakpoint" },
  { "<F6>", ":lua require'dap'.continue()<CR>",          desc = "DAP Continue" },
  { "<F7>", ":lua require'dap'.step_into()<CR>",         desc = "DAP Step into" },
  { "<F8>", ":lua require'dap'.step_over()<CR>",         desc = "DAP Step over" },
  { "<F9>", ":lua require'dap'.step_out()<CR>",          desc = "DAP Step out" },
  { "<Leader>di", ":lua require'dapui'.toggle()<CR>",    desc = "DAP UI" },
  { "<Leader>dro", ":lua require'dap'.repl.open()<CR>",  desc = "DAP UI" },
  { "<Leader>dbc", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    desc = "DAP UI" },
  { "<Leader>dbm", ":lua require'dap'.set_breakpoint({ nil, nil, vim.fn.input('Log point message: ') })<CR>",
    desc = "DAP UI" },
}

-- one-small-step-for-vimkind
-- https://github.com/jbyuki/one-small-step-for-vimkind
vim.api.nvim_create_user_command('OsvDebugger', require"osv".launch, {})
