return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          layout = { layout = { width = 30 } },
        },
        files = { hidden = true },
        grep = { hidden = true },
      },
    },
  },
}
