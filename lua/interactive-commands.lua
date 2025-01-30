-- https://www.reddit.com/r/neovim/comments/1i8kuxw/bash_cannot_set_terminal_process_group_1/
local api = vim.api

api.nvim_create_user_command("R", function(opts)
  local cmd = opts.args ---@type string

  local factor = 0.85
  local term_width = math.floor(vim.o.columns * factor)
  local term_height = math.floor(vim.o.lines * factor)
  local term_col = (vim.o.columns - term_width) / 2
  local term_row = (vim.o.lines - term_height) / 2

  local term_buf = api.nvim_create_buf(false, true)
  api.nvim_open_win(term_buf, true, {
    relative = "editor",
    width = term_width,
    height = term_height,
    col = term_col,
    row = term_row,
  })

  local tmp_file = os.tmpname()

  local job_id = vim.fn.termopen(("%s > %s"):format(cmd, tmp_file), {
    on_exit = function()
      api.nvim_buf_delete(term_buf, { force = true })

      local file = io.open(tmp_file, "r")
      if not file then return end
      local out = file:read "*a"
      file:close()

      local row, _ = unpack(api.nvim_win_get_cursor(0)) ---@type integer, integer
      api.nvim_buf_set_lines(0, row, row, true, vim.split(out, "\n", { trimempty = true }))
    end,
  })
  if job_id == 0 then
    return vim.notify("Invalid aruguments", vim.log.levels.ERROR)
  elseif job_id == -1 then
    return vim.notify(("cmd %s is not executable"):format(cmd), vim.log.levels.ERROR)
  end
  vim.cmd.startinsert()
end, { nargs = "*", force = true })
