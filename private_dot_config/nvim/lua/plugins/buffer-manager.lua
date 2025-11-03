return {
  {
    "j-morano/buffer_manager.nvim",
    config = {
      line_keys = "1234567890",
      select_menu_item_commands = {
        edit = {
          key = "<CR>",
          command = "edit",
        },
        v = {
          key = "<C-v>",
          command = "vsplit",
        },
        h = {
          key = "<C-h>",
          command = "split",
        },
      },
      focus_alternate_buffer = true,
      width = nil,
      height = nil,
      short_file_names = false,
      show_depth = true,
      short_term_names = false,
      loop_nav = false,
      highlight = "Normal:BufferManagerBorder",
      win_extra_options = {
        winhighlight = "Normal:BufferManagerBorder",
        -- relativenumbe = true,
      },
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      format_function = nil,
      order_buffers = nil,
      show_indicators = "after",
      toggle_key_bindings = { "q", "<ESC>" },
      use_shortcuts = false,
    },
  },
}
