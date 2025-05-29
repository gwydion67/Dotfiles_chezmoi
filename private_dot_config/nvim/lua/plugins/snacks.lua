return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            ignored = false,
            hidden = false,
          },
          files = {
            ignored = false,
            hidden = false,
          },
        },
      },
    },
    keys = {
      { "<leader>/", false },
      {
        "<leader>s.",
        function()
          Snacks.picker()
        end,
        desc = "Show all pickers",
      },
      {
        "<leader>seh",
        function()
          -- Get the current config
          local config = require("snacks").config
          -- Toggle the hidden setting
          config.picker.sources.explorer.hidden = not config.picker.sources.explorer.hidden
          -- Notify about the change
          vim.notify("Explorer hidden files: " .. (config.picker.sources.explorer.hidden and "shown" or "hidden"))
        end,
        desc = "Toggle explorer hidden files",
      },
      {
        "<leader>sei",
        function()
          -- Get the current config
          local config = require("snacks").config
          -- Toggle the ignored setting
          config.picker.sources.explorer.ignored = not config.picker.sources.explorer.ignored
          -- Notify about the change
          vim.notify("Explorer ignored files: " .. (config.picker.sources.explorer.ignored and "shown" or "hidden"))
        end,
        desc = "Toggle explorer ignored files",
      },
      {
        "<leader>sfh",
        function()
          -- Get the current config
          local config = require("snacks").config
          -- Toggle the hidden setting
          config.picker.sources.files.hidden = not config.picker.sources.files.hidden
          -- Notify about the change
          vim.notify("files hidden files: " .. (config.picker.sources.files.hidden and "shown" or "hidden"))
        end,
        desc = "Toggle hidden files",
      },
      {
        "<leader>sfi",
        function()
          -- Get the current config
          local config = require("snacks").config
          -- Toggle the ignored setting
          config.picker.sources.files.ignored = not config.picker.sources.files.ignored
          -- Notify about the change
          vim.notify("files ignored files: " .. (config.picker.sources.files.ignored and "shown" or "hidden"))
        end,
        desc = "Toggle ignored files",
      },
    },
  },
}
