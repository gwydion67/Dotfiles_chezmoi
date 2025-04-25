return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>/", false },
      {
        "<leader>s.",
        function()
          Snacks.picker()
        end,
        desc = "Show all pickers",
      },
    },
  },
}
