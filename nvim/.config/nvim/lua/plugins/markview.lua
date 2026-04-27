return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  opts = {
    preview = {
      -- filetypes = { "markdown", "quarto", "rmd", "typst", "asciidoc", "codecompanion" },
      filetypes = { "codecompanion" },
      icon_provider = "mini",
      --ignore_buftypes = {},
    },
  },
  dependencies = {
    "nvim-mini/mini.icons",
  },
}
