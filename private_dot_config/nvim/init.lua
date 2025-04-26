-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("plugin_confs")
-- add a notification welcoming the user
local function welcome()
  local msg = "Welcome to LazyVim! Enjoy coding❕"
  vim.notify(msg, vim.log.levels.INFO, { title = "LazyVim" })
end
welcome()
