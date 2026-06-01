-- Purpose: Ctrl+` (with Ctrl+' and F7 as fallbacks) toggles a bottom
-- horizontal terminal, identical to <Leader>th. Uses toggleterm's default
-- terminal (id 1); lazygit lives on id 101+, so this never lands on lazygit.
return {
  "akinsho/toggleterm.nvim",
  optional = true,
  init = function()
    -- Apply after AstroNvim has set its own terminal mappings (VeryLazy) so ours win.
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      desc = "Bind Ctrl+`/Ctrl+'/F7 to a bottom horizontal terminal",
      callback = function()
        local rhs = "<Cmd>ToggleTerm size=10 direction=horizontal<CR>"
        for _, key in ipairs { "<C-`>", "<C-'>", "<F7>" } do
          vim.keymap.set({ "n", "i", "t" }, key, rhs, { desc = "Toggle horizontal terminal" })
        end
      end,
    })
  end,
}
