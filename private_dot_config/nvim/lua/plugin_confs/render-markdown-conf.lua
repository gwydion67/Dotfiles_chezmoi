require("render-markdown").setup({
  -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'.
  -- There are two special states for unchecked & checked defined in the markdown grammar.
  checkbox = {
    custom = {
      todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
      fire = { raw = "[f]", rendered = "🔥", highlight = "RenderMarkdownTodo", scope_highlight = nil },
      cross = { raw = "[c]", rendered = "✗", highlight = "RenderMarkdownTodo", scope_highlight = nil },
    },
  },
})
