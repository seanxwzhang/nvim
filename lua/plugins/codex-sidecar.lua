-- Codex sidecar: <Leader>ax toggles a right-hand terminal running `codex`,
-- mirroring the claudecode.nvim Claude sidecar on <Leader>ac (same snacks
-- terminal, same right / 30%-width placement). The terminal is keyed by the
-- current working directory, so toggling reuses the same sidecar per dir and it
-- naturally follows the worktree root when you drop into one via the agent
-- panel's `e`.
--
-- In visual mode <Leader>ax instead *sends the selection* to that same codex
-- sidecar — the parallel to <Leader>as (ClaudeCodeSend) for Claude. claudecode
-- has a websocket protocol to push an at-mention; codex is just a pty, so we
-- paste the selected lines (prefixed with a `path:lines` reference) straight
-- into its prompt and leave the cursor there for you to type your request.

-- Shared spec so the toggle and the visual-send resolve the *same* snacks
-- terminal. snacks keys terminals by cmd + cwd + env + count, so as long as both
-- run from the editor's cwd they map to one sidecar.
local function codex_opts()
  return {
    start_insert = true,
    auto_insert = true,
    auto_close = false,
    win = { position = "right", width = 0.30, height = 0, relative = "editor" },
  }
end

local function toggle_codex()
  require("snacks.terminal").toggle("codex", codex_opts())
end

local function send_to_codex()
  -- While a mode="v" mapping fires we're still in visual mode, so '< / '> aren't
  -- updated yet; read the live 'v' (other end) and '.' (cursor) marks with the
  -- current mode for an exact region (charwise, linewise, or block).
  local mode = vim.fn.mode()
  local p1, p2 = vim.fn.getpos "v", vim.fn.getpos "."
  local lines = vim.fn.getregion(p1, p2, { type = mode })
  -- Leave visual mode; the actual terminal work is deferred to vim.schedule so
  -- this <Esc> is fully processed (in the editor) before we focus the codex pty.
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  if not lines or #lines == 0 then return end

  local l1, l2 = math.min(p1[2], p2[2]), math.max(p1[2], p2[2])
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local header = (l1 == l2) and string.format("%s:%d", path, l1) or string.format("%s:%d-%d", path, l1, l2)
  local payload = header .. "\n" .. table.concat(lines, "\n")

  vim.schedule(function()
    -- Ensure the codex sidecar exists and is visible, then push the selection
    -- into its pty. Bracketed paste (ESC[200~ … ESC[201~) makes the codex TUI
    -- treat the whole block as one paste, so embedded newlines don't submit it
    -- line-by-line.
    local term = require("snacks.terminal").get("codex", codex_opts())
    if not term then return end
    if not term:win_valid() then term:show() end
    local chan = term.buf and vim.bo[term.buf].channel
    if not chan or chan == 0 then return end
    vim.fn.chansend(chan, "\27[200~" .. payload .. "\27[201~")
    -- Drop into the codex prompt in insert mode to type the request.
    if term:win_valid() then
      vim.api.nvim_set_current_win(term.win)
      vim.cmd.startinsert()
    end
  end)
end

return {
  "folke/snacks.nvim",
  optional = true,
  keys = {
    { "<Leader>a", nil, desc = "AI/Claude Code" },
    { "<Leader>ax", toggle_codex, desc = "Toggle Codex" },
    { "<Leader>ax", send_to_codex, mode = "v", desc = "Send to Codex" },
  },
}
