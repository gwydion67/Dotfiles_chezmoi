-- Helper function to show [Venn] when enabled
local function venn_status()
  return vim.b.venn_enabled and '📝 Venn' or ''
end

-- Get your existing lualine config
local lualine = require('lualine')
local config = lualine.get_config()

-- Append the Venn indicator to lualine_c (or any section you like)
table.insert(config.sections.lualine_c, {
  venn_status,
  color = { fg = '#f7768e', gui = 'bold' }, -- Optional: color the indicator
})

-- Apply updated config
lualine.setup(config)
