return {
  {
    "2kabhishek/exercism.nvim",
    cmd = { "Exercism" },
    keys = { "<leader>Exa", "<leader>Exl", "<leader>Exr" }, -- add your preferred keybindings
    dependencies = {
      "2kabhishek/utils.nvim", -- required, for utility functions
      -- "2kabhishek/termim.nvim", -- optional, better UX for running tests
    },
    -- Add your custom configs here, keep it blank for default configs (required)
    config = function()
      local exercism = require("exercism");
      exercism.setup({
        exercism_workspace = "~/D_drive/Projects/learning/exercism", -- Default workspace for exercism exercises
        default_language = "cpp", -- Default language for exercise list
        add_default_keybindings = true, -- Whether to add default keybindings
        max_recents = 30, -- Maximum number of recent exercises to keep
        icons = {
          concept = "", -- Icon for concept exercises
          practice = "", -- Icon for practice exercises
        },
      })
    end,
    opts = {},
  },
}
