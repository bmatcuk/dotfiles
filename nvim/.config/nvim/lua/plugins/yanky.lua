return {
  {
    "gbprod/yanky.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {
      system_clipboard = {
        sync_with_ring = false,
      },
      highlight = {
        timer = 250,
      },
    },
    keys = {
      { "<leader>p", function() Snacks.picker.yanky() end,
        desc = "Open yank history.",
        silent = true,
      },
    },
  },
}
