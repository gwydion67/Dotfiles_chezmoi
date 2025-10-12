-- Get the directory of the current script
-- local current_dir = debug.getinfo(1).source:match("@?(.*/)") or ""
-- package.path = package.path .. ";" .. current_dir .. "?.lua"
-- require("render-markdown.conf")

require("plugin_confs.render-markdown-conf")
require("plugin_confs.mini-snippets")
require("plugin_confs.lualine")
require("plugin_confs.lspconfig")
