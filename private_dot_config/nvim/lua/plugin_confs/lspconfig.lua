require("lspconfig").clangd.setup({
  cmd = {
    "/usr/bin/clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
    -- "--compile-commands-dir=" .. vim.fn.getcwd(),
    "--compile-commands-dir=.",
  },
})

