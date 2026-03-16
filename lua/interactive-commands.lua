-- https://www.reddit.com/r/neovim/comments/1i8kuxw/bash_cannot_set_terminal_process_group_1/
local api = vim.api

---@param cmd string
---@param callback? fun(start_row: integer, line_count: integer)
local function run_in_float(cmd, callback)
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
      local out = file:read("*a")
      file:close()
      os.remove(tmp_file)

      local lines = vim.split(out, "\n", { trimempty = true })

      local start_row, _ = unpack(api.nvim_win_get_cursor(0)) ---@type integer, integer
      api.nvim_buf_set_lines(0, start_row, start_row, true, lines)

      if callback then
        callback(start_row, #lines)
      end
    end,
  })

  if job_id == 0 then
    return vim.notify("Invalid aruguments", vim.log.levels.ERROR)
  elseif job_id == -1 then
    return vim.notify(("cmd %s is not executable"):format(cmd), vim.log.levels.ERROR)
  end

  vim.cmd.startinsert()
end


-- Run interactive command and write its lines to the next line.
api.nvim_create_user_command("R", function(opts)
  run_in_float(opts.args)
end, { nargs = "*", force = true })


-- Generate fixup! Git commit message.
vim.api.nvim_create_user_command("Gfup", function()
  run_in_float("git fup", function(start_row, count)
    if count > 0 then
      local line = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1]
      vim.api.nvim_buf_set_lines(0, start_row, start_row + 1, false, { "fixup! " .. line })
    end
  end)
end, {})
