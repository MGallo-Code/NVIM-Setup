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

local claude = require("config.claude")

local function ask(opts)
  return function() claude.ask(opts) end
end

vim.keymap.set("n", "<leader>aa", ask({ mode = "lite" }), { desc = "Ask Claude (new)" })
vim.keymap.set("x", "<leader>aa", ask({ mode = "lite", visual = true }), { desc = "Ask Claude about selection (new)" })
vim.keymap.set("n", "<leader>ac", ask({ mode = "lite", continue = true }), { desc = "Ask Claude (continue)" })
vim.keymap.set("x", "<leader>ac", ask({ mode = "lite", visual = true, continue = true }), { desc = "Ask Claude about selection (continue)" })
vim.keymap.set("n", "<leader>ai", ask({ mode = "full" }), { desc = "Ask Claude (implement: full env)" })
vim.keymap.set("x", "<leader>ai", ask({ mode = "full", visual = true }), { desc = "Ask Claude about selection (implement)" })
vim.keymap.set("n", "<leader>an", claude.clear, { desc = "Clear Claude scratch" })
vim.keymap.set("n", "<leader>aw", claude.toggle, { desc = "Toggle Claude window" })
