-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }
local keymap = LazyVim.safe_keymap_set
local wk = require("which-key")

local function entity_close()
  local ok, _ = pcall(vim.cmd.close)
  if not ok then
    Snacks.bufdelete()
  end
end

vim.keymap.del("n", "<leader>l")

-- normal mode
keymap("i", "kj", "<Esc>", opts)
keymap("i", "jk", "<Esc>", opts)
keymap("i", "kk", "<Esc>", opts)
keymap("i", "jj", "<Esc>", opts)
-- save
keymap("n", "ss", ":w<CR>", opts)

keymap("n", "<Esc>", "<Esc><cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })
-- toggle comment
keymap("n", "<Leader>/", "<cmd>normal gcc<cr>", { desc = "Toggle Comment" })
-- close all
keymap("n", "<C-x>", entity_close, opts)
-- formatting
keymap({ "n", "v" }, "<leader>lf", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })

-- open ToggleTerm in float
keymap("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "Open Terminal" })

-- Setup WhichKey for LSP diagnostics
wk.add({
  { "<leader>l", group = "LSP Actions",icon= "" },
  {
    "<leader>lj",
    function()
      vim.diagnostic.jump({ count = 1, float = true })
    end,
    desc = "Go to next diagnostic",
  },
  {
    "<leader>lk",
    function()
      vim.diagnostic.jump({ count = -1, float = true })
    end,
    desc = "Go to previous diagnostic",
  },
  { "<leader>lv", vim.diagnostic.open_float, desc = "View Current Line Diagnostic" },
})
