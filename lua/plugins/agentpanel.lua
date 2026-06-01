-- agentpanel — Codex-like agent panel.
--
-- Extracted into a standalone, open-source plugin:
--   https://github.com/seanxwzhang/agentpanel.nvim
-- This spec pulls it in (<Leader>m toggles the modal panel) and injects its
-- worktree component into the heirline statusline, just before the git branch.
return {
  -- The plugin itself.
  {
    "seanxwzhang/agentpanel.nvim",
    cmd = { "AgentPanel", "AgentPanelNew" },
    keys = {
      { "<Leader>m", "<cmd>AgentPanel<cr>", desc = "Agent panel" },
    },
    opts = {},
  },

  -- Statusline: show the active worktree just before the branch.
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      -- Make sure the module (and its statusline autocmds) are initialized.
      -- Requiring agentpanel here makes lazy pull in the plugin on demand.
      require("agentpanel").setup()
      local component = require("agentpanel.statusline").component

      local sl = opts.statusline
      if type(sl) ~= "table" then return end
      -- Default AstroNvim statusline is { hl=..., mode(), git_branch(), ... };
      -- insert our worktree component right before git_branch (array index 2).
      -- Fall back to a safe position if the layout differs.
      local idx = (sl[1] ~= nil and sl[2] ~= nil) and 2 or (#sl + 1)
      table.insert(sl, idx, component)
    end,
  },
}
