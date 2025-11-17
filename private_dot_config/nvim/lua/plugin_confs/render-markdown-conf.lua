require("render-markdown").setup({
  -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'.
  -- There are two special states for unchecked & checked defined in the markdown grammar.
  latex = {
    -- Turn on / off latex rendering.
    enabled = false,
    -- Additional modes to render latex.
    render_modes = false,
    -- Executable used to convert latex formula to rendered unicode.
    -- If a list is provided the commands run in order until the first success.
    converter = { "utftex", "latex2text" },
    -- Highlight for latex blocks.
    highlight = "RenderMarkdownMath",
    -- Determines where latex formula is rendered relative to block.
    -- | above  | above latex block                               |
    -- | below  | below latex block                               |
    -- | center | centered with latex block (must be single line) |
    position = "center",
    -- Number of empty lines above latex blocks.
    top_pad = 0,
    -- Number of empty lines below latex blocks.
    bottom_pad = 0,
  },
  checkbox = {
    custom = {
      todo = { raw = "[~]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
      fire = { raw = "[!]", rendered = "🔥", highlight = "RenderMarkdownTodo", scope_highlight = nil },
      cross = { raw = "[>]", rendered = "✗", highlight = "RenderMarkdownTodo", scope_highlight = nil },
    },
  },
})
