return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  opts = {
    preview = {
      file_types = { "markdown", "quarto", "rmd", "typst", "asciidoc", "codecompanion" },
      icon_provider = "mini",
      --ignore_buftypes = {},
    },
  },
  dependencies = {
    "nvim-mini/mini.icons",
  },
}
