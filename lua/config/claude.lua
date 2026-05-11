local M = {}

local SYSTEM_PROMPT = table.concat({
  "Be concise. Markdown output. No preamble.",
  "Prefer code examples and inline comments over prose explanations.",
  "When prose is unavoidable, keep it short and follow it with a code snippet that makes the point concretely.",
}, " ")
local NS = vim.api.nvim_create_namespace("claude_ask_placeholders")
local scratch_buf = nil

local function build_cmd(opts)
  local cmd = {
    "claude", "-p",
    "--model", "opus",
    "--append-system-prompt", SYSTEM_PROMPT,
  }
  if opts.mode == "lite" then
    vim.list_extend(cmd, {
      "--strict-mcp-config",
      "--mcp-config", '{"mcpServers":{}}',
      "--allowed-tools", "Read,Grep,Glob",
    })
  end
  if opts.continue then
    table.insert(cmd, "--continue")
  end
  if opts.add_dir then
    table.insert(cmd, "--add-dir")
    table.insert(cmd, opts.add_dir)
  end
  return cmd
end

local function get_visual_selection()
  local mode = vim.fn.visualmode()
  if mode == "" then mode = "v" end
  local s = vim.fn.getpos("'<")
  local e = vim.fn.getpos("'>")
  local ok, lines = pcall(vim.fn.getregion, s, e, { type = mode })
  if not ok or not lines or #lines == 0 then return nil end
  return table.concat(lines, "\n")
end

local function find_or_create_buffer()
  if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
    return scratch_buf
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false
  vim.bo[buf].filetype = "markdown"
  vim.keymap.set("n", "q", "<cmd>close<cr>",
    { buffer = buf, nowait = true, silent = true, desc = "Close Claude float" })
  scratch_buf = buf
  return buf
end

local function visible_window(buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then return win end
  end
  return nil
end

local function float_config()
  local height = math.floor(vim.o.lines * 0.35)
  local width = vim.o.columns - 4
  return {
    relative = "editor",
    width = width,
    height = height,
    col = 2,
    row = vim.o.lines - height - 4,
    border = "rounded",
    title = " Claude ",
    title_pos = "center",
    style = "minimal",
  }
end

local function open_float(buf, focus)
  local existing = visible_window(buf)
  if existing then
    if focus then vim.api.nvim_set_current_win(existing) end
    return existing
  end
  local win = vim.api.nvim_open_win(buf, focus == true, float_config())
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].number = false
  vim.wo[win].signcolumn = "no"
  vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
  return win
end

local AUGROUP = vim.api.nvim_create_augroup("claude_ask", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
  group = AUGROUP,
  callback = function()
    if not (scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf)) then return end
    local win = visible_window(scratch_buf)
    if win then pcall(vim.api.nvim_win_set_config, win, float_config()) end
  end,
})

local function append_lines(buf, lines)
  vim.bo[buf].modifiable = true
  local count = vim.api.nvim_buf_line_count(buf)
  local at_empty = count == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
  vim.api.nvim_buf_set_lines(buf, at_empty and 0 or count, -1, false, lines)
  vim.bo[buf].modifiable = false
end

local SELECTION_PREVIEW_LINES = 12

local function trim_for_preview(text, max_lines)
  local lines = vim.split(text, "\n", { plain = true })
  if #lines <= max_lines then return lines end
  local keep = math.floor(max_lines / 2)
  local result = vim.list_slice(lines, 1, keep)
  table.insert(result, string.format("... (%d more lines) ...", #lines - 2 * keep))
  for _, line in ipairs(vim.list_slice(lines, #lines - keep + 1)) do
    table.insert(result, line)
  end
  return result
end

local function append_question_block(buf, question, ctx)
  local has_content = vim.api.nvim_buf_line_count(buf) > 1
    or (vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or "") ~= ""
  local prelude = has_content and { "", "---", "" } or {}

  table.insert(prelude, "> " .. question)

  if ctx.filename then
    local badge = ctx.filename
    if ctx.line_range then badge = badge .. ":" .. ctx.line_range end
    table.insert(prelude, "_" .. badge .. "_")
  end

  if ctx.selection then
    table.insert(prelude, "```" .. (ctx.filetype or ""))
    for _, line in ipairs(trim_for_preview(ctx.selection, SELECTION_PREVIEW_LINES)) do
      table.insert(prelude, line)
    end
    table.insert(prelude, "```")
  end

  table.insert(prelude, "")
  table.insert(prelude, "_Asking Claude..._")
  append_lines(buf, prelude)

  local placeholder_line = vim.api.nvim_buf_line_count(buf) - 1
  return vim.api.nvim_buf_set_extmark(buf, NS, placeholder_line, 0, {})
end

local function replace_placeholder(buf, mark_id, body_lines)
  local pos = vim.api.nvim_buf_get_extmark_by_id(buf, NS, mark_id, {})
  if not pos or not pos[1] then return end
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, pos[1], pos[1] + 1, false, body_lines)
  vim.bo[buf].modifiable = false
  vim.api.nvim_buf_del_extmark(buf, NS, mark_id)
end

function M.ask(opts)
  opts = opts or {}
  local selection = opts.visual and get_visual_selection() or nil
  local filetype = vim.bo.filetype
  local filepath = vim.fn.expand("%:p")
  local has_real_file = filepath ~= "" and vim.bo.buftype == ""
  local add_dir = has_real_file and vim.fn.fnamemodify(filepath, ":h") or nil
  local display_name = has_real_file and vim.fn.fnamemodify(filepath, ":~:.") or nil
  local line_range = nil
  if opts.visual then
    local s, e = vim.fn.line("'<"), vim.fn.line("'>")
    line_range = (s == e) and tostring(s) or (s .. "-" .. e)
  end

  vim.ui.input({ prompt = "Ask Claude: " }, function(question)
    if opts.visual then pcall(vim.cmd, "normal! gv") end
    if not question or question == "" then return end

    local parts = {}
    if has_real_file then
      table.insert(parts, "Current file: " .. filepath)
      table.insert(parts, "")
    end
    if selection then
      table.insert(parts, "```" .. filetype)
      table.insert(parts, selection)
      table.insert(parts, "```")
      table.insert(parts, "")
    end
    table.insert(parts, question)
    local stdin_payload = table.concat(parts, "\n")

    local buf = find_or_create_buffer()
    open_float(buf, false)
    local mark_id = append_question_block(buf, question, {
      filename = display_name,
      line_range = line_range,
      selection = selection,
      filetype = filetype,
    })
    local started = vim.uv.hrtime()

    local cmd = build_cmd({
      mode = opts.mode or "lite",
      continue = opts.continue,
      add_dir = add_dir,
    })
    vim.system(cmd, {
      stdin = stdin_payload,
      text = true,
    }, function(result)
      vim.schedule(function()
        local elapsed_s = (vim.uv.hrtime() - started) / 1e9
        local body
        if result.code == 0 then
          body = (result.stdout or ""):gsub("%s+$", "")
        else
          body = string.format("**Error (exit %d)**\n\n```\n%s\n```",
            result.code, result.stderr or "")
        end
        local footer = string.format("\n\n_%.1fs_", elapsed_s)
        replace_placeholder(buf, mark_id,
          vim.split(body .. footer, "\n", { plain = true }))
      end)
    end)
  end)
end

function M.clear()
  if not (scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf)) then return end
  vim.bo[scratch_buf].modifiable = true
  vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, {})
  vim.bo[scratch_buf].modifiable = false
end

function M.toggle()
  if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
    local win = visible_window(scratch_buf)
    if win then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  open_float(find_or_create_buffer(), true)
end

return M
