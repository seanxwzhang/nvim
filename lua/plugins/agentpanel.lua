-- agentpanel — Codex-like agent panel.
--
-- This used to live in-tree under lua/agentpanel/; it has been extracted into a
-- standalone, open-source plugin: https://github.com/seanxwzhang/agentpanel.nvim
-- This spec just pulls it in and binds <Leader>m to toggle the modal panel.
--
-- (The plugin also ships an optional heirline worktree-statusline component,
-- agentpanel.statusline — not wired here.)
return {
  "seanxwzhang/agentpanel.nvim",
  cmd = { "AgentPanel", "AgentPanelNew" },
  keys = {
    { "<Leader>m", "<cmd>AgentPanel<cr>", desc = "Agent panel" },
  },
  opts = {},
}
