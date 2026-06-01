-- Purpose: show the file's directory path in the winbar of the active window,
-- before the LSP symbol breadcrumbs, for orientation in a large monorepo.
return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require "astroui.status"
    local winbar = opts.winbar
    -- AstroNvim's winbar: [1] = inactive (already shows separated_path),
    -- [2] = active window (breadcrumbs only). Wrap [2] to prepend the path.
    if type(winbar) == "table" and winbar[2] then
      local active = winbar[2]
      winbar[2] = {
        status.component.separated_path { max_depth = 5 },
        active,
      }
    end
  end,
}
