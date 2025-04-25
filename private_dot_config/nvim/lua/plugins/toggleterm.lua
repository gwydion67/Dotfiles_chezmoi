return {
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    version = "*",
    keys = {
      { "<C-.>", mode = { "t" }, "<C-\\><C-N>", desc = "Normal mode in terminal" },
      { "<C-t>", mode = { "n", "t" }, "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
    opts = {
      open_mapping = nil,
      direction = "float",
    },
  },
}
