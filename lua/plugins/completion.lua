return {
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = {
        preset = "none",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      -- appearance = { use_nvim_highlights = true },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },
}
