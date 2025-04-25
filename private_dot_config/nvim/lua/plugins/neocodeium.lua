-- add this to the file where you setup your other plugins:
return {
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    keys = {
      {
        "<A-f>",
        mode = { "i" },
        function()
          local neocodeium = require("neocodeium")
          neocodeium.accept()
        end,
        { desc = "Accept completion" },
      },
      {
        "<A-c>",
        mode = { "i" },
        function()
          local neocodeium = require("neocodeium")
          neocodeium.cancel()
        end,
        { desc = "Cancel completion" },
      },
    },
    config = function()
      local neocodeium = require("neocodeium")
      neocodeium.setup({
        enabled = false,
      })
    end,
  },
}
