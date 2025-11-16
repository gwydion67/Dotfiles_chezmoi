-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- vim.api.nvim_create_autocmd("User", {
--   pattern = "BlinkCmpMenuOpen",
--   callback = function()
--     vim.b.copilot_suggestion_hidden = true
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "BlinkCmpMenuClose",
--   callback = function()
--     vim.b.copilot_suggestion_hidden = false
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "buffer_manager",
  callback = function()
    vim.api.nvim_command("vnoremap <silent> J :m '>+1<CR>gv=gv")
    vim.api.nvim_command("vnoremap <silent> K :m '<-2<CR>gv=gv")
  end,
})

-- In your Neovim config (init.lua or a plugin file)
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*.md",
  callback = function()
    local width = vim.o.columns
    local config = {
      config = {
        MD013 = {
          line_length = width - 10, -- Leave some margin
          code_blocks = false,
          tables = false,
        },
      },
    }
    local config_file = vim.fn.stdpath("config") .. "/.markdownlint-cli2.jsonc"
    local f = io.open(config_file, "w")
    if f then
      f:write(vim.json.encode(config))
      f:close()
    end
  end,
})
