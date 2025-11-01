-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("plugin_confs")
-- add a notification welcoming the user
local function welcome()
  local msg = "Welcome to LazyVim! Enjoy coding❕"
  vim.notify(msg, vim.log.levels.INFO, { title = "LazyVim" })
end
-- welcome()

local ok, keys = pcall(require, "secrets")
if not ok then
  vim.notify("Failed to load API keys from secrets/api_keys.lua", vim.log.levels.ERROR)
else
  -- Set environment variables for keys
  for name, key in pairs(keys) do
    vim.env[name:upper()] = key
  end
end

vim.g.firenvim_config = {
  globalSettings = { alt = "all" },
  localSettings = {
    [".*"] = {
      cmdline = "neovim",
      content = "text",
      priority = 0,
      selector = "textarea",
      takeover = "never",
    },
  },
}
