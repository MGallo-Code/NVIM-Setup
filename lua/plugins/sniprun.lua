return {
  "michaelb/sniprun",
  branch = "master",
  build = "sh install.sh",
  event = "VeryLazy",
  config = function(_, opts)
    require("sniprun").setup(opts)
    vim.keymap.set("n", "<leader>sr", "<cmd>SnipRun<cr>", { desc = "SnipRun line" })
    vim.keymap.set("x", "<leader>sr", ":SnipRun<cr>", { desc = "SnipRun selection" })
    vim.keymap.set("n", "<leader>sc", "<cmd>SnipClose<cr>", { desc = "SnipRun close output" })
    vim.keymap.set("n", "<leader>sR", "<cmd>SnipReset<cr>", { desc = "SnipRun reset" })
  end,
  opts = {
    display = { "VirtualTextOk", "TerminalWithCode" },
    show_no_output = { "Classic" },
    display_options = {
      terminal_position = "horizontal",
      terminal_height = 15,
    },
    interpreter_options = {
      TypeScript_original = {
        interpreter = "tsx",
      },
    },
  },
}
