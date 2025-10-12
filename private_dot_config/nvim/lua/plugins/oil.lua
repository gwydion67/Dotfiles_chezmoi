-- EDIT FILES IN BUFFER


return {
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" } },
    },
    config = function()
      require("oil").setup({
        default_file_explorer = false,
        delete_to_trash = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
        },
        win_options = {
          wrap = true,
        },
      })
    end,
  },
}
