-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim.create_autocmd("FileType", {
  pattern = "harpoon",
  callback = function()
    vim.keymap.set("n", "<C-c>", function()
      require("harpoon.ui").toggle_quick_menu()
    end, { buffer = true, silent = true })
  end,
})
