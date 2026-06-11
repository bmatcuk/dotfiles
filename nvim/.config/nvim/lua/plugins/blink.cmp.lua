return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    branch = "v1",
    opts = {
      completion = {
        ghost_text = {
          enabled = false,
        },
      },
      keymap = {
        preset = "enter",

        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      },
      sources = {
        default = { "lsp", "buffer", "path" },
      },
    },
  },
}
