local gen_loader = require("mini.snippets").gen_loader
local tsx_patters = {
  "**/html.json",
  "**/typescript.json",
  "**/*react-ts.json",
  "**/*next-ts.json",
  "**/*react-native-ts.json",
  "**/*react-es7.json",
}
local lang_patterns = { tsx = tsx_patters }
require("mini.snippets").setup({
  snippets = {
    -- Load custom file with global snippets first (adjust for Windows)
    gen_loader.from_file("~/.config/nvim/snippets/global.json"),

    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    gen_loader.from_lang(),
    gen_loader.from_lang({ lang_patterns = lang_patterns }),
  },
})
