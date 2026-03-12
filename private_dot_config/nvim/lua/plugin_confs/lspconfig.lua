vim.lsp.config("clangd", {
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

vim.lsp.config("qmlls", {
  cmd = { "qmlls", "-E" },
})

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = { enable = false },
    },
  },
})
