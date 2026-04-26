-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Fix terminal toggle opening a new terminal when focused in a terminal buffer.
-- LazyVim.root() resolves differently from terminal buffers, producing a different
-- terminal ID and creating a second terminal. Cache the root from the last normal
-- buffer so the cwd stays consistent when toggling from terminal mode.
local _term_cwd = nil

local function term_toggle()
  if vim.bo.buftype ~= "terminal" then
    _term_cwd = LazyVim.root()
  end
  Snacks.terminal(nil, { cwd = _term_cwd or LazyVim.root() })
end

local function term_toggle_right()
  if vim.bo.buftype ~= "terminal" then
    _term_cwd = LazyVim.root()
  end
  Snacks.terminal(nil, { cwd = _term_cwd or LazyVim.root(), count = 2, win = { position = "right" } })
end

vim.keymap.set({ "n", "t" }, "<c-/>", term_toggle, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<c-_>", term_toggle, { desc = "which_key_ignore" })
vim.keymap.set({ "n", "t" }, "<c-]>", term_toggle_right, { desc = "Terminal (Right)" })
